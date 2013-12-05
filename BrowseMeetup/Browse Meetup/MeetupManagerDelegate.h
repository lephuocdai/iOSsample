//
//  MeetupManagerDelegate.h
//  BrowseMeetup
//
//  Created by レー フックダイ on 12/6/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetupManagerDelegate

- (void)didReceiveGroups:(NSArray *)groups;
- (void)fetchingGroupsFailedWithError:(NSError *)error;

@end
