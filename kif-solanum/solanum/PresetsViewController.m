//
//  PresetsViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "PresetsViewController.h"

NSString * const kSelectPresetNotification = @"SolanumSelectPresetNotification";

@interface PresetsViewController ()

@end

@implementation PresetsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.tableView setAccessibilityLabel:@"Presets List"];
  [self.tableView setIsAccessibilityElement:YES];
}

- (NSArray *)presetItems
{
  static dispatch_once_t token;
  static NSArray *presets;
  dispatch_once(&token, ^{
    presets = @[
      @{ @"name": @"Classic", @"workTime": @25, @"breakTime": @5, @"reps": @4 },
      @{ @"name": @"Express", @"workTime": @15, @"breakTime": @2, @"reps": @3 },
      @{ @"name": @"Focused", @"workTime": @40, @"breakTime": @5, @"reps": @2 },
      @{ @"name": @"Slacker", @"workTime": @10, @"breakTime": @20, @"reps": @6 },
      @{ @"name": @"Slacker Pro+", @"workTime": @5, @"breakTime": @25, @"reps": @1 },
    ];
  });

  return presets;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self presetItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"PresetCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

  NSDictionary *presetItem = [self presetItems][indexPath.row];
  [cell.textLabel setText:presetItem[@"name"]];
  [cell.detailTextLabel setText:[NSString stringWithFormat:@"Work %@ mins, Break %@ mins, %@x", presetItem[@"workTime"], presetItem[@"breakTime"], presetItem[@"reps"]]];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSDictionary *presetItem = [self presetItems][indexPath.row];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPresetNotification object:self userInfo:presetItem];
}

@end
