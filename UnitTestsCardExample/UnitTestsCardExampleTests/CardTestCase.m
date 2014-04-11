//
//  CardTestCase.m
//  UnitTestsCardExample
//
//  Created by レー フックダイ on 3/31/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Card.h"   

@interface CardTestCase : XCTestCase

@end

@implementation CardTestCase

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
    [super tearDown];
}

/**
- (void)testExample {
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
**/

- (void)testMatchesDifferentCardWithSameContents {
    Card *card1 = [[Card alloc] init];
    card1.contents = @"one";
    Card *card2 = [[Card alloc] init];
    card2.contents = @"one";
    
    NSArray *handOfCards = @[card2];
    int matchCount = [card1 match:handOfCards];
    
    XCTAssertEqual(matchCount, 1, @"Should have matched");
    
}

- (void)testDoesNotMatchDifferentCard {
    Card *card1 = [[Card alloc] init];
    card1.contents = @"one";
    Card *card2 = [[Card alloc] init];
    card2.contents = @"two";
    
    NSArray *handOfCards = @[card2];
    int matchCount = [card1 match:handOfCards];
    XCTAssertEqual(matchCount, 0, @"No matches, right?");
}

- (void)testMatchesForAtLeastOneCard {
//    NSLog(@"%s doing work...", __PRETTY_FUNCTION__);
    Card *card1 = [[Card alloc] init];
    card1.contents = @"one";
    Card *card2 = [[Card alloc] init];
    card2.contents = @"two";
    Card *card3 = [[Card alloc] init];
    card3.contents = @"one";
    NSArray *arrayOfCards = @[card2, card3];
    int matchCount = [card1 match:arrayOfCards];
    XCTAssertEqual(matchCount, 1, @"Should have matched at least 1");
}


@end
