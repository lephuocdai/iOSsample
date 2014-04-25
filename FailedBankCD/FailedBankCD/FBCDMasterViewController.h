//
//  FBCDMasterViewController.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCDMasterViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSArray *failedBankInfos;
@property (nonatomic, retain) NSFetchedResultsController *fetchResultsController;


@end
