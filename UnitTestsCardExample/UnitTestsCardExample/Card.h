//
//  Card.h
//  UnitTestsCardExample
//
//  Created by レー フックダイ on 3/30/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
