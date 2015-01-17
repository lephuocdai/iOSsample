//
//  TimerViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "TimerViewController.h"
#import "WorkViewController.h"

@interface TimerViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;

@property (weak, nonatomic) IBOutlet UISlider *workTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *breakTimeSlider;
@property (weak, nonatomic) IBOutlet UIStepper *repsStepper;

@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *breakTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;

@end

@implementation TimerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self refresh];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectPreset:) name:kSelectPresetNotification object:nil];

  [self.repsStepper setAccessibilityLabel:@"Reps Stepper"];
}

- (void)refresh
{
  [self workTimeDidChange:self.workTimeSlider];
  [self breakTimeDidChange:self.breakTimeSlider];
  [self repsDidChange:self.repsStepper];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidSelectPreset:(NSNotification *)notification
{
  NSDictionary *preset = [notification userInfo];

  [self.workTimeSlider setValue:[preset[@"workTime"] floatValue]];
  [self.breakTimeSlider setValue:[preset[@"breakTime"] floatValue]];
  [self.repsStepper setValue:[preset[@"reps"] doubleValue]];

  [self refresh];

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPresets:(UIStoryboardSegue *)segue {
}

- (IBAction)giveUp:(UIStoryboardSegue *)segue {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue destinationViewController] isKindOfClass:[WorkViewController class]]) {
    WorkViewController *work = [segue destinationViewController];

    [work setTaskName:([self.taskNameField.text isEqualToString:@""] ? @"Some random task" : self.taskNameField.text)];
    [work setWorkMinutes:(int)[self.workTimeSlider value]];
    [work setBreakMinutes:(int)[self.breakTimeSlider value]];
    [work setReps:(int)[self.repsStepper value]];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

- (IBAction)workTimeDidChange:(UISlider *)sender {
  [self.workTimeLabel setText:[NSString stringWithFormat:@"%d minutes", (int)sender.value]];
}

- (IBAction)breakTimeDidChange:(UISlider *)sender {
  [self.breakTimeLabel setText:[NSString stringWithFormat:@"%d minutes", (int)sender.value]];
}

- (IBAction)repsDidChange:(UIStepper *)sender {
  [self.repsLabel setText:[NSString stringWithFormat:@"%d time%@", (int)sender.value, (int)sender.value == 1 ? @"" : @"s"]];
}

@end
