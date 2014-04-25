//
//  main.m
//  CoreDataTutorial2
//
//  Created by レー フックダイ on 4/24/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "FailedBankInfo.h"
#import "FailedBankDetails.h"

static NSManagedObjectModel *managedObjectModel() {
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
//    NSString *path = @"CoreDataTutorial2";
//    path = [path stringByDeletingPathExtension];
    NSString *path = @"FailedBankCD";
    
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext() {
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        // Custom code here...
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        
        NSError *err = nil;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Banks" ofType:@"json"];
        NSArray *Banks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
        NSLog(@"Imported Banks: %@", Banks);
        
        [Banks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FailedBankInfo *failedBankInfo = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo"
                                                                           inManagedObjectContext:context];
            failedBankInfo.name = [obj objectForKey:@"name"];
            failedBankInfo.city = [obj objectForKey:@"city"];
            failedBankInfo.state = [obj objectForKey:@"state"];
            FailedBankDetails *failedBankDetails = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails"
                                                                                 inManagedObjectContext:context];
            failedBankDetails.closeDate = [NSDate dateWithString:[obj objectForKey:@"closeDate"]];
            failedBankDetails.updateDate = [NSDate date];
            failedBankDetails.zip = [obj objectForKey:@"zip"];
            failedBankDetails.info = failedBankInfo;
            failedBankInfo.details = failedBankDetails;
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Save error: %@", [error localizedDescription]);
            }
            
            // Test listing all FailedBankInfos from the store
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo" inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (FailedBankInfo *info in fetchObjects) {
                NSLog(@"Name: %@", info.name);
                FailedBankDetails *details = info.details;
                NSLog(@"Zip: %@", details.zip);
            }
        }];
        
    }
    return 0;
}

