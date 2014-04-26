//
//  SMBankDetailViewController.h
//  FailedBankCD
//
//  Created by レー フックダイ on 4/25/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedBankInfo.h"
#import "FailedBankDetails.h"

@interface SMBankDetailViewController : UIViewController

@property (nonatomic, strong) FailedBankInfo *bankInfo;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *cityField;
@property (nonatomic, weak) IBOutlet UITextField *zipField;
@property (nonatomic, weak) IBOutlet UITextField *stateField;
@property (nonatomic, weak) IBOutlet UILabel *tagsLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

- (id)initWithBankInfo:(FailedBankInfo*)info;

@end
