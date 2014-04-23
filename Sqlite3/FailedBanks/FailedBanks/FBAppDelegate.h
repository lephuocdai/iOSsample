//
//  FBAppDelegate.h
//  FailedBanks
//
//  Created by レー フックダイ on 4/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedBankDatabase.h"
#import "FailedBankInfo.h"


@interface FBAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *_navController;
}

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *navController;


@end
