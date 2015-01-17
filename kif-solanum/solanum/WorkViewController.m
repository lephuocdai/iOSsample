//
//  WorkViewController.m
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "WorkViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, WorkState) {
  WorkStateWorking,
  WorkStateBreak,
};

NSString * const kWorkedNotification = @"worked";

NSString * const kHistoryTaskNameKey = @"taskName";
NSString * const kHistoryTotalWorkKey = @"totalWork";
NSString * const kHistoryTotalBreakKey = @"totalBreak";
NSString * const kHistoryCompletedSetKey = @"completedSet";
NSString * const kHistoryFinishTimeKey = @"finishedAt";

@interface WorkViewController ()

@property (nonatomic, weak) IBOutlet UILabel *taskLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation WorkViewController {
  BOOL _isRunning;
  WorkState _state;
  NSInteger _countdown;
  NSTimer *_timer;
  AVAudioPlayer *_alertSound;
}

- (void)dealloc
{
  if (_timer) {
    [_timer invalidate];
    _timer = nil;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"alert"
                                            withExtension:@"caf"];
  _alertSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  [_alertSound prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if (!_isRunning) [self startTimer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [_timer invalidate];
  _timer = nil;

  NSMutableArray *historyEntries;

  if ([[NSUserDefaults standardUserDefaults] objectForKey:kSettingsHistoryKey]) {
    historyEntries = [(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kSettingsHistoryKey] mutableCopy];
  } else {
    historyEntries = [NSMutableArray array];
  }

  [historyEntries insertObject:
   @{ kHistoryTaskNameKey: self.taskName,
      kHistoryTotalWorkKey: @(_totalWork),
      kHistoryTotalBreakKey: @(_totalBreak),
      kHistoryCompletedSetKey: @(sender == self),
      kHistoryFinishTimeKey: [NSDate date] } atIndex:0];

  [[NSUserDefaults standardUserDefaults] setObject:[historyEntries copy] forKey:kSettingsHistoryKey];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [[NSNotificationCenter defaultCenter] postNotificationName:kWorkedNotification object:self userInfo:nil];
}

- (void)startTimer
{
  [self.taskLabel setText:self.taskName];
  [self.titleLabel setText:@"Get to Work!"];
  [self.timeLabel setText:[NSString stringWithFormat:@"%ld minutes to go", (long)self.workMinutes]];

  NSTimeInterval tickTime = [[NSUserDefaults standardUserDefaults] boolForKey:kSettingsDebugModeKey] ? 0.5 : 60;

  _timer = [NSTimer scheduledTimerWithTimeInterval:tickTime target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];

  _state = WorkStateWorking;
  _countdown = self.workMinutes;

  _isRunning = YES;
}

- (void)timerTick:(NSTimer *)timer
{
  _countdown--;

  if (_state == WorkStateWorking) {
    _totalWork++;
  } else {
    _totalBreak++;
  }

  if (_countdown == 0) {
    [_alertSound play];

    if (_state == WorkStateWorking) {
      self.reps--;

      if (self.reps == 0) {
        [self performSegueWithIdentifier:@"finishWork" sender:self];
        return;
      }

      _state = WorkStateBreak;
      [self.titleLabel setText:@"Take a Break!"];
      _countdown = self.breakMinutes;
    } else {
      _state = WorkStateWorking;
      [self.titleLabel setText:@"Get to Work!"];
      _countdown = self.workMinutes;
    }
  }

  NSString *text;
  if (_countdown == 1) {
    text = [NSString stringWithFormat:@"Less than a minute left"];
  } else {
    text = [NSString stringWithFormat:@"%d minutes to go", (int)_countdown];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.timeLabel setText:text];
  });
}

@end
