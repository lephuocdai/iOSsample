//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by レー フックダイ on 3/27/14.
//  Copyright (c) 2014 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation;

@end
