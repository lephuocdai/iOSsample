//
//  DetailsViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (nonatomic, weak) IBOutlet UITableViewCell *workCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *breakCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *repsCell;

@end

@implementation DetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.workCell.detailTextLabel setText:[NSString stringWithFormat:@"%@ minutes", self.details[kHistoryTotalWorkKey]]];
  [self.breakCell.detailTextLabel setText:[NSString stringWithFormat:@"%@ minutes", self.details[kHistoryTotalBreakKey]]];
  [self.repsCell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [self.details[kHistoryCompletedSetKey] boolValue] ? @"Yes! :]" : @"No!"]];
}

@end
