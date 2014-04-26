//
//  SMTagListViewController.m
//  FailedBankCD
//
//  Created by レー フックダイ on 4/26/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "SMTagListViewController.h"

@interface SMTagListViewController ()

@end

@implementation SMTagListViewController

@synthesize bankDetails = _bankDetails;
@synthesize pickedTags;
@synthesize fetchResultsController = _fetchResultsController;

- (id)initWithBankDetails:(FailedBankDetails *)details {
    if (self = [super init]) {
        _bankDetails = details;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickedTags = [[NSMutableSet alloc] init];
    // Retrieve all tags
    NSError *error;
    if (![self.fetchResultsController performFetch:&error]) {
        NSLog(@"Error in tag retrieval %@, %@", error, [error userInfo]);
        abort();
    }
    // Each tag attached to the details is included in the array
    NSSet *tags = self.bankDetails.tags;
    for (Tag *tag in tags) {
        [pickedTags addObject:tag];
    }
    // Setting up add button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTag)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"TagCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    Tag *tag = (Tag*)[self.fetchResultsController objectAtIndexPath:indexPath];
    if ([pickedTags containsObject:tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = tag.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tag *tag = (Tag*)[self.fetchResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if ([pickedTags containsObject:tag]) {
        [pickedTags removeObject:tag];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [pickedTags addObject:tag];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (NSFetchedResultsController*)fetchResultsController {
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.bankDetails.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.bankDetails.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchResultsController = aFetchedResultsController;
    NSError *error = nil;
    if (![self.fetchResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchResultsController;
}

- (void)addTag {
    UIAlertView *newTagAlert = [[UIAlertView alloc] initWithTitle:@"New tag"
                                                          message:@"Insert new tag name"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Save", nil];
    newTagAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [newTagAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel");
    } else {
        NSString *tagName = [[alertView textFieldAtIndex:0] text];
        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.bankDetails.managedObjectContext];
        tag.name = tagName;
        NSError *error = nil;
        if (![tag.managedObjectContext save:&error]) {
            NSLog(@"Core data error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.fetchResultsController performFetch:&error];
        [self.tableView reloadData];
    }
}


@end
