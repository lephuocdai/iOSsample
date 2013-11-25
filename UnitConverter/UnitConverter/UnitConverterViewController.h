//
//  UnitConverterViewController.h
//  UnitConverter
//
//  Created by レー フックダイ on 11/25/13.
//  Copyright (c) 2013 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitConverterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tempText;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
- (IBAction)convertTemp:(id)sender;

@end
