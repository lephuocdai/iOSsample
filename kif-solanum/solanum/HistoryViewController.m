//
//  HistoryViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "HistoryViewController.h"
#import "DetailsViewController.h"

@implementation HistoryViewController {
  NSMutableArray *_historyEntries;
  NSDateFormatter *_dateFormatter;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self refreshData];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kWorkedNotification object:nil];
}

- (void)refreshData
{
  _historyEntries = [(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
  [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  UIViewController *dest = [segue destinationViewController];
  if ([dest isKindOfClass:[DetailsViewController class]]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [(DetailsViewController *)dest setDetails:_historyEntries[indexPath.row]];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_historyEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"HistoryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

  NSDictionary *item = _historyEntries[indexPath.row];
  NSDate *finishedAt = item[kHistoryFinishTimeKey];

  [cell.textLabel setText:item[kHistoryTaskNameKey]];

  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  }

  [cell.detailTextLabel setText:[_dateFormatter stringFromDate:finishedAt]];

#ifdef DEBUG
  [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
#endif

  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [_historyEntries removeObjectAtIndex:indexPath.row];

  [[NSUserDefaults standardUserDefaults] setObject:[_historyEntries copy] forKey:kSettingsHistoryKey];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleDelete;
}

@end
