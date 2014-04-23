//
//  FailedBankDetails.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FailedBankInfo;

@interface FailedBankDetails : NSManagedObject

@property (nonatomic) int32_t zip;
@property (nonatomic) NSTimeInterval closeDate;
@property (nonatomic) NSTimeInterval updateDate;
@property (nonatomic, retain) FailedBankInfo *info;

@end
