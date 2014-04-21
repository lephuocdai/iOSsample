//
//  NSManagedObject+JSON.m
//  SignificantDates
//
//  Created by レー フックダイ on 4/21/14.
//
//

#import "NSManagedObject+JSON.h"

@implementation NSManagedObject (JSON)

- (NSDictionary*)JSONToCreateObjectOnServer {
    @throw [NSException exceptionWithName:@"JSONStringToCreateObjectOnServer Not Overridden"
                                   reason:@"Must override JSONStringToCreateObjectOnServer on NSManagedObject class"
                                 userInfo:nil];
}

@end
