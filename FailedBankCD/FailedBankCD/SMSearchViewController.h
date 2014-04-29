//
//  SMSearchViewController.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/30/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedBankInfo.h"

@interface SMSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) UILabel *noResultsLabel;

- (IBAction)closeSearch;

@end
