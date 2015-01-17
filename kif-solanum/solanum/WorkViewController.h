//
//  WorkViewController.h
//  solanum
//
//  Created by Greg Heo on 2013-12-08.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkViewController : UIViewController

@property (nonatomic, copy) NSString *taskName;

@property (nonatomic) NSInteger workMinutes;
@property (nonatomic) NSInteger breakMinutes;
@property (nonatomic) NSInteger reps;

@property (nonatomic, readonly) NSInteger totalWork;
@property (nonatomic, readonly) NSInteger totalBreak;

@end
