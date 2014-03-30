//
//  PAPSettingsActionSheetDelegate.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/9/12.
//

#import <Foundation/Foundation.h>

@interface PAPSettingsActionSheetDelegate : NSObject <UIActionSheetDelegate>

// Navigation controller of calling view controller
@property (nonatomic, strong) UINavigationController *navController;

- (id)initWithNavigationController:(UINavigationController *)navigationController;

@end
