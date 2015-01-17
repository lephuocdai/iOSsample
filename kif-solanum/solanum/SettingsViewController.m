//
//  SettingsViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "SettingsViewController.h"

NSString * const kSettingsDebugModeKey = @"debugMode";
NSString * const kSettingsHistoryKey = @"history";

@interface SettingsViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UISwitch *debugModeSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.debugModeSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kSettingsDebugModeKey]];
}

- (IBAction)toggleDebugModeSwitch:(UISwitch *)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kSettingsDebugModeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)clearHistoryTapped:(id)sender
{
  [[[UIAlertView alloc] initWithTitle:@"Clear History?" message:@"Clear all work and task history?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [self clearHistory];
  }
}

- (void)clearHistory
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettingsHistoryKey];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [[NSNotificationCenter defaultCenter] postNotificationName:kWorkedNotification object:self userInfo:nil];
}

@end
