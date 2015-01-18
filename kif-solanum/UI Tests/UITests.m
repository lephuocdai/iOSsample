//
//  UITests.m
//  solanum
//
//  Created by レー フックダイ on 1/17/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

#import "UITests.h"

@implementation UITests

- (void)beforeAll {
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Debug Mode"];
    [tester tapViewWithAccessibilityLabel:@"Clear History"];
    [tester tapViewWithAccessibilityLabel:@"Clear"];
}

- (void)test00TabBarButtons {
    [tester tapViewWithAccessibilityLabel:@"History"];
    [tester waitForViewWithAccessibilityLabel:@"History List"];
    
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    [tester waitForViewWithAccessibilityLabel:@"Task Name"];
    
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester waitForViewWithAccessibilityLabel:@"Debug Mode"];
}


- (void)test10PresetTimer {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester enterText:@"Set up a test" intoViewWithAccessibilityLabel:@"Task Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];
    
    [self selectPresetAtIndex:1];
    
    UISlider *slider = (UISlider*)[tester waitForViewWithAccessibilityLabel:@"Work Time Slider"];
    STAssertEqualsWithAccuracy([slider value], 15.0f, 0.1, @"Work time slider was not set!");
    
}

#pragma mark - Helper
- (void)selectPresetAtIndex:(NSInteger)index {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester tapViewWithAccessibilityLabel:@"Presets"];
    [tester tapRowInTableViewWithAccessibilityLabel:@"Presets List" atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Presets List"];
}


@end
