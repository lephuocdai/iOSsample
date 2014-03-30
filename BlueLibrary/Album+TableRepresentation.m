//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by レー フックダイ on 3/27/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation {
    return @{@"titles": @[@"Artist", @"Album", @"Genre", @"Year"],
             @"values": @[self.artist, self.title, self.genre, self.year]};
}


@end
