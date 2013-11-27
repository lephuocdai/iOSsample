//
//  UnitConverterViewController.m
//  UnitConverter
//
//  Created by レー フックダイ on 11/25/13.
//  Copyright (c) 2013 lephuocdai. All rights reserved.
//

#import "UnitConverterViewController.h"

@interface UnitConverterViewController ()

@end

@implementation UnitConverterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)convertTemp:(id)sender {
    double fahrenheit = [_tempText.text doubleValue];
    double celcius = (fahrenheit - 31)/1.8;
    
    NSString *resultString = [[NSString alloc] initWithFormat:@"Celcius %f", celcius];
    _resultLabel.text = resultString;
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([_tempText isFirstResponder] && [touch view] != _tempText) {
        [_tempText resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
