//
//  FailedBankDetails.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/26/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FailedBankInfo, Tag;

@interface FailedBankDetails : NSManagedObject

@property (nonatomic) NSDate *closeDate;
@property (nonatomic) NSDate *updateDate;
@property (nonatomic) int32_t zip;
@property (nonatomic, retain) FailedBankInfo *info;
@property (nonatomic, retain) NSSet *tags;
@end

@interface FailedBankDetails (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
