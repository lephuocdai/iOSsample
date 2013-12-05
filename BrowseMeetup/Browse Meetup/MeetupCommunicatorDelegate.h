//
//  MeetupCommunicatorDelegate.h
//  BrowseMeetup
//
//  Created by レー フックダイ on 12/5/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetupCommunicatorDelegate

- (void)receivedGroupsJSON:(NSData *)objectNotation;
- (void)fetchingGroupsFailedWithError:(NSError *)error;

@end
