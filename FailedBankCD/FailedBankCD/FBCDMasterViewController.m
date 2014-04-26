//
//  FBCDMasterViewController.m
//  FailedBankCD
//
//  Created by レー フックダイ on 4/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "FBCDMasterViewController.h"
#import "FailedBankInfo.h"
#import "FailedBankDetails.h"
#import "SMBankDetailViewController.h"

@interface FBCDMasterViewController ()

@end

@implementation FBCDMasterViewController

@synthesize managedObjectContext;
//@synthesize failedBankInfos;
@synthesize fetchResultsController = _fetchResultsController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entity];
    
    NSError *error;
    if (![[self fetchResultsController] performFetch:&error]) {
        // Update to handle the error appropriately
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); // Failed
    }
//    self.failedBankInfos = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.title = @"Failed Banks";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBank)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
}

- (void)viewDidUnload {
    self.fetchResultsController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController*)fetchResultsController {
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"details.closeDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:managedObjectContext
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:@"Root"];
    self.fetchResultsController = theFetchedResultsController;
    _fetchResultsController.delegate = self;
    return _fetchResultsController;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[_fetchResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    FailedBankInfo *info = [_fetchResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", info.city, info.state];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [managedObjectContext deleteObject:[self.fetchResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FailedBankInfo *info = [_fetchResultsController objectAtIndexPath:indexPath];
    SMBankDetailViewController *detailViewController = [[SMBankDetailViewController alloc] initWithBankInfo:info];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma makr - NSFetchResultsController delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to processs all updates
    [self.tableView endUpdates];
}

#pragma mark BarButtonItem Action
- (void)addBank {
    FailedBankInfo *failedBankInfo = (FailedBankInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo"
                                                                                     inManagedObjectContext:managedObjectContext];
    failedBankInfo.name = @"Test Bank";
    failedBankInfo.city = @"Testville";
    failedBankInfo.state = @"Testland";
    
    FailedBankDetails *failedBankDetails = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails"
                                                                         inManagedObjectContext:managedObjectContext];
    failedBankDetails.closeDate = [NSDate date];
    failedBankDetails.updateDate = [NSDate date];
    failedBankDetails.zip = [NSNumber numberWithInt:123];
    failedBankDetails.info = failedBankInfo;
    failedBankInfo.details = failedBankDetails;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error in adding a new bank %@, %@", error, [error userInfo]);
        abort();
    }
}


@end
