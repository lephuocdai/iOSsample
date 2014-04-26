//
//  SMTagListViewController.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/26/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedBankDetails.h"
#import "Tag.h"

@interface SMTagListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) FailedBankDetails *bankDetails;
@property (nonatomic, strong) NSMutableSet *pickedTags;
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;

- (id)initWithBankDetails:(FailedBankDetails*)details;

@end
