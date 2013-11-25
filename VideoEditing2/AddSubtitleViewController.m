//
//  AddSubtitleViewController.m
//  VideoEditingPart2
//
//  Created by Abdul Azeem Khan on 3/19/13.
//  Copyright (c) 2013 com.datainvent. All rights reserved.
//

#import "AddSubtitleViewController.h"

@interface AddSubtitleViewController ()

@end

@implementation AddSubtitleViewController

- (IBAction)loadAsset:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

- (IBAction)generateOutput:(id)sender {
    [self videoOutput];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{

}


@end
