//
//  Tag.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/26/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FailedBankDetails;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bankdetails;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addBankdetailsObject:(FailedBankDetails *)value;
- (void)removeBankdetailsObject:(FailedBankDetails *)value;
- (void)addBankdetails:(NSSet *)values;
- (void)removeBankdetails:(NSSet *)values;

@end
