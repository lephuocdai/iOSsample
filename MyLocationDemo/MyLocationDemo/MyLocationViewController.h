//
//  MyLocationViewController.h
//  MyLocationDemo
//
//  Created by レー フックダイ on 12/7/13.
//  Copyright (c) 2013 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)getCurrentLocation:(id)sender;

@end
