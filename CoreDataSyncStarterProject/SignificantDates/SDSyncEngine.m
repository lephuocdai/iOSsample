//
//  SDSyncEngine.m
//  SignificantDates
//
//  Created by レー フックダイ on 4/17/14.
//
//

#import "SDSyncEngine.h"
#import "SDCoreDataController.h"
#import "NSManagedObject+JSON.h"

@interface SDSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;

@end

NSString * const kSDSyncEngineInitialCompleteKey = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SDSyncEngineSyncCompleted";

@implementation SDSyncEngine

@synthesize registeredClassesToSync = _registeredClassesToSync;
@synthesize syncInProgress = _syncInProgress;

+ (SDSyncEngine*)sharedEngine {
    static SDSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SDSyncEngine alloc] init];
    });
    return sharedEngine;
}

- (NSDateFormatter*)formatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    });
    return formatter;
}

- (void)startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        });
    }
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync)
        self.registeredClassesToSync = [NSMutableArray array];
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)])
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        else
            NSLog(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
    } else
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
}

- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSDSyncEngineSyncCompletedNotificationName object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}

- (NSDate*)mostRecentUpdatedAtDateForEntityWithName:(NSString*)entityName {
    __block NSDate *date = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt"
                                                                                       ascending:NO]]];
    [request setFetchLimit:1];
    [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])
            date = [[results lastObject] valueForKey:@"updatedAt"];
    }];
    return date;
}

- (void)newManagedObjectWithClassName:(NSString*)className forRecord:(NSDictionary*)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className
                                                                      inManagedObjectContext:[[SDCoreDataController sharedInstance]
                                                                                              backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:SDObjectSynced] forKey:@"syncStatus"];
}

- (void)postLocalObjectsToServer {
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync) {
        // Fetch all objects from Core Data whose syncStatus is equal to SDObjectCreated
        NSArray *objectsToCreate = [self managedObjectsForClass:className withSyncStatus:SDObjectCreated];
        for (NSManagedObject *objectToCreate in objectsToCreate) {
            // Get the JSON representation of the NSManagedObject
            NSDictionary *jsonString = [objectToCreate JSONToCreateObjectOnServer];
            // Create a request using your POST method with the JSON representation of the NSManagedObject
            NSMutableURLRequest *request = [[SDAFParseAPIClient sharedClient] POSTRequestForClass:className parameters:jsonString];
            AFHTTPRequestOperation *operation = [[SDAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // Set the completion block for the operation to update the NSMangedObject with the createdDate from the remote service
                // and objectId, then set the syncStatus to SDObjectSynced so that the sync engine does not attempt to create it again
                NSLog(@"Success creation %@", responseObject);
                NSDictionary *responseDictionary = responseObject;
                NSDate *createdDate = [self dateUsingStringFromAPI:[responseDictionary valueForKey:@"createdAt"]];
                [objectToCreate setValue:createdDate forKey:@"createdAt"];
                [objectToCreate setValue:[responseDictionary valueForKey:@"objectId"] forKey:@"objectId"];
                [objectToCreate setValue:[NSNumber numberWithInt:SDObjectSynced] forKey:@"syncStatus"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // Log an error if there was one, proper error handling should be done if nessessary, in this case it may not be required
                // to do anything as the object will attempt to sync again next time. There could be a possibility that the data was
                // malformed, fields are missing, extra fields were present etc... so it is a good idea to determine the best error
                // handling approach for your production applications
                NSLog(@"Failed creattion %@", error);
            }];
            [operations addObject:operation];
        }
    }
    [[SDAFParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        // Save the background context after all operations have completed
        if ([operations count] > 0)
            [[SDCoreDataController sharedInstance] saveBackgroundContext];
        // Execute the sync completed operations
        [self executeSyncCompletedOperations];
    }];
}

- (void)updateManagedObject:(NSManagedObject*)managedObject withRecord:(NSDictionary*)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject*)managedObject {
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request
                                                             returningResponse:&response
                                                                         error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else
        [managedObject setValue:value forKey:key];
}

- (NSArray*)managedObjectsForClass:(NSString*)className withSyncStatus:(SDObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    return results;
}

- (NSArray*)managedObjectsForClass:(NSString*)className sortedByKey:(NSString*)key usingArrayOfIds:(NSArray*)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = (inIds) ? [NSPredicate predicateWithFormat:@"objectId IN %@", idArray] :
    [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    return results;
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate)
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        NSMutableURLRequest *request = [[SDAFParseAPIClient sharedClient] GEtRequestForAllRecordsOfClass:className updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[SDAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self writeJSONResponse:responseObject toDiskForClassWithName:className];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request for class %@ failed with error: %@", className, error);
        }];
        [operations addObject:operation];
    }
    
    [[SDAFParseAPIClient sharedClient]
     enqueueBatchOfHTTPRequestOperations:operations
     progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        if (!toDelete)
            [self processJSONDataRecordsIntoCoreData];
        else
            [self processJSONDataRecordsForDeletion];
    }];
}

- (NSDate*)dateUsingStringFromAPI:(NSString*)dateString {
    // NSDateFormatter does not like ISO 8601 so strip milliseconds and timezone
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length] - 5)];
    return [[self formatter] dateFromString:dateString];
}

- (NSString*)dateStringForAPIUsingDate:(NSDate*)date {
    NSString *dateString = [[self formatter] stringFromDate:date];
    // Remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length] - 1)];
    // Add milliseconds and put Z back on
    dateString = [dateString stringByAppendingString:@".000Z"];
    return dateString;
}

#pragma mark - File Management
- (NSURL*)applicationCacheDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)JSONDataRecordsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }
    return url;
}

- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString*)className {
    NSURL *fileURL = [NSURL URLWithString:className
                            relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary*)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // Remove NSNulls and try again...
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]])
                    [nullFreeRecord setValue:nil forKey:key];
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES])
            NSLog(@"Failed all attempts to save response to disk: %@", response);
    }
}

#pragma mark - Parsing data from disk
- (NSDictionary*)JSONDictionaryForClassWithName:(NSString*)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

- (NSArray*)JSONDataRecordsForClass:(NSString*)className sortedByKey:(NSString*)key {
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}

- (void)deleteJSONDataRecordsForClassWithName:(NSString*)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted)
        NSLog(@"Unable to delete JSON Record at %@, reason: %@", url, error);
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    // Iterate over all registered classes to sync
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) { // Import all downloaded data to Core Data for initial sync
            // If this is the initial sync then the logic is pretty simple, you will fetch the JSON data from disk
            // for the class of the current iteration and create new NSManagedObjects for each record
            NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
            NSArray *records = [JSONDictionary objectForKey:@"results"];
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            // Otherwise you need to do some more logic to determine if the record is new or has been updated
            // First get the downloaded records from the JSON response, verify there is at least one object in the data,
            // and then fetch all records stored in Core Data whose objectId matches those from the JSON response
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
            if ([downloadedRecords lastObject]) {
                // Now you have a set of objects from the remote service and all of the matching objects (based on objectId)
                // from your Corde Data store. Iterate over all of the downloaded records from the remote service
                NSArray *storedRecords = [self managedObjectsForClass:className sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                // If the number of records in your Core Data store is less than the currentIndex, you know that you have
                // a potential match between the downloaded records and stored records because you sorted both lists by objectId,
                // this means that an update has come in from the remote service
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    // Make sure we don't access an index that is out of bounds as we are iterating over both collections together
                    if ([storedRecords count] > currentIndex)
                        storedManagedObject = [storedRecords objectAtIndex:currentIndex];
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        // Do a quick spot check to validate the objectIds in fact do match, if they do update the stored
                        // object with the values received from the remote service
                        [self updateManagedObject:[storedRecords objectAtIndex:currentIndex] withRecord:record];
                    } else {
                        // Otherwise you have a new object coming in from your remote service so create a new NSManagedObject to represent this remote object locally
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        // Once all NSManagedObjects are created in your context you can save the context to persist the objects to your persistent store.
        // In this case though you used an NSManagedObjectContext who has a parent context so all changes will be pushed to the parent context
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error])
                NSLog(@"Unable to save context for class %@", className);
        }];
        // You are now done with the downloaded JSON responses so you can delete them to clean up after yourself, then save off your master context
        // and set the syncInProgress flag to NO
        [self deleteJSONDataRecordsForClassWithName:className];
//        [self executeSyncCompletedOperations];
    }
    [self downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
}

- (void)processJSONDataRecordsForDeletion {
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    for (NSString *className in self.registeredClassesToSync) {
        // Retrieve the JSON records from disk
        NSArray *JSONRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
        if ([JSONRecords count] > 0) { // If there are any records, fetch all locally stored records that are NOT in the list of downloaded records
            NSArray *storedRecords = [self managedObjectsForClass:className
                                                      sortedByKey:@"objectId"
                                                  usingArrayOfIds:[JSONRecords valueForKey:@"objectId"]
                                                     inArrayOfIds:NO];
            // Schedule the NSManagedObject for deletion and save the context
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in storedRecords) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved)
                    NSLog(@"Unable to save context after deleting records for class %@ because %@", className, error);
            }];
        }
        // Delete all JSON Record response files to clean up after yourself
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    // The final step of the sync process
    [self executeSyncCompletedOperations];
}


@end
























