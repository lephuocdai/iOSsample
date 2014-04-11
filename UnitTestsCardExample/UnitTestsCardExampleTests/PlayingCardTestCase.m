//
//  PlayingCardTestCase.m
//  UnitTestsCardExample
//
//  Created by レー フックダイ on 3/31/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingCard.h"

@interface PlayingCardTestCase : XCTestCase

@end

@implementation PlayingCardTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTheValidSuits {
    NSArray *theSuits = [PlayingCard validSuits];
    int howMany = [theSuits count];
    
    XCTAssertEqual(howMany, 4, @"Should be only 4");
    
    XCTAssertTrue([theSuits containsObject:@"♥"], "@Must have a heart");
    XCTAssertTrue([theSuits containsObject:@"♦"], "@Must have a diamond");
    XCTAssertTrue([theSuits containsObject:@"♠"], "@Must have a spade");
    XCTAssertTrue([theSuits containsObject:@"♣"], "@Must have a club");
}

- (void)testSetSuitInvalidRejected {
    PlayingCard *card = [[PlayingCard alloc] init];
    [card setSuit:@"A"];
    
    XCTAssertEqualObjects(card.suit, @"?", "Should not have been recognized");
    XCTAssertNotEqualObjects(card.suit, @"A", "Should not have matched");
}

@end
