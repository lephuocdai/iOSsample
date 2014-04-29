//
//  SMBankDetailViewController.m
//  FailedBankCD
//
//  Created by レー フックダイ on 4/25/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "SMBankDetailViewController.h"
#import "SMTagListViewController.h"

@interface SMBankDetailViewController ()
- (void)hidePicker;
- (void)showPicker;
@end

@implementation SMBankDetailViewController

@synthesize bankInfo = _bankInfo;
@synthesize nameField;
@synthesize cityField;
@synthesize zipField;
@synthesize stateField;
@synthesize tagsLabel;
@synthesize dateLabel;
@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBankInfo:(FailedBankInfo *)info {
    if (self = [super init]) {
        _bankInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.bankInfo.name;
    // Setting the right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveBankInfo)];
    // Setting interaction on date label
    self.dateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTapped)];
    [self.dateLabel addGestureRecognizer:dateTapRecognizer];
    // Set date picker handler
    [datePicker addTarget:self action:@selector(dateHasChanged:) forControlEvents:UIControlEventValueChanged];
    // Setting interaction on tag label
    self.tagsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tagsTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagsTapped)];
    [self.tagsLabel addGestureRecognizer:tagsTapRecognizer];
    
    self.tagsLabel.backgroundColor = self.dateLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    NSSet *tags = self.bankInfo.details.tags;
    NSMutableArray *tagNamesArray = [[NSMutableArray alloc] initWithCapacity:tags.count];
    for (Tag *tag in tags) {
        [tagNamesArray addObject:tag];
    }
    self.tagsLabel.text = [tagNamesArray componentsJoinedByString:@","];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBankInfo {
    self.bankInfo.name = self.nameField.text;
    self.bankInfo.city = self.cityField.text;
    self.bankInfo.details.zip = [NSNumber numberWithInt:[self.zipField.text intValue]];
    self.bankInfo.state = self.stateField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.bankInfo.details.closeDate = [dateFormatter dateFromString:self.dateLabel.text];
    NSError *error;
    if ([self.bankInfo.managedObjectContext hasChanges] && ![self.bankInfo.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateTapped {
    [self showPicker];
}

- (void)dateHasChanged:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.datePicker.date];
}

- (void)showPicker {
    [self.zipField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.stateField resignFirstResponder];
    [self.cityField resignFirstResponder];
    
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.datePicker.transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}

- (void)hidePicker {
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    self.datePicker.transform = CGAffineTransformMakeTranslation(0, 216);
    [UIView commitAnimations];
}

- (void)tagsTapped {
    SMTagListViewController *tagPicker = [[SMTagListViewController alloc] initWithBankDetails:self.bankInfo.details];
    [self.navigationController pushViewController:tagPicker animated:YES];
}




@end
