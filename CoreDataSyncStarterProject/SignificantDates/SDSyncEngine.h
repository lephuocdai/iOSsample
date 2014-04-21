//
//  SDSyncEngine.h
//  SignificantDates
//
//  Created by レー フックダイ on 4/17/14.
//
//

#import <Foundation/Foundation.h>
#import "SDAFParseAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine*)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end

typedef enum {
    SDObjectSynced = 0,
    SDObjectCreated,
//    SDObjectDeleted,
} SDObjectSyncStatus;


