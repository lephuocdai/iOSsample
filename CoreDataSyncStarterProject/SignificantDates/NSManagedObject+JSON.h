//
//  NSManagedObject+JSON.h
//  SignificantDates
//
//  Created by レー フックダイ on 4/21/14.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

- (NSDictionary*)JSONToCreateObjectOnServer;
- (NSString*)dateStringForAPIUsingDate:(NSDate*)date;

@end
