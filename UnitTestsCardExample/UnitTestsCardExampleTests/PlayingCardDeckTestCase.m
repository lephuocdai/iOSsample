//
//  PlayingCardDeckTestCase.m
//  UnitTestsCardExample
//
//  Created by レー フックダイ on 3/31/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardDeckTestCase : XCTestCase

@end

@implementation PlayingCardDeckTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlayingCardDeckHasTheCorrectInitialCards {
    PlayingCardDeck *deck = [[PlayingCardDeck alloc] init];
    NSMutableArray *hearts = [@[] mutableCopy];
    NSMutableArray *diamonds = [@[] mutableCopy];
    NSMutableArray *clubs = [@[] mutableCopy];
    NSMutableArray *spades = [@[] mutableCopy];
    
    PlayingCard *randomCard;
    do {
        randomCard = (PlayingCard *)[deck drawRandomCard];
        if ([randomCard.suit isEqualToString:@"♥"]) [hearts addObject:randomCard];
        if ([randomCard.suit isEqualToString:@"♦"]) [diamonds addObject:randomCard];
        if ([randomCard.suit isEqualToString:@"♠"]) [spades addObject:randomCard];
        if ([randomCard.suit isEqualToString:@"♣"]) [clubs addObject:randomCard];
    } while (randomCard);
    
    NSUInteger expectedCount = 13;
    XCTAssertEqual([hearts count], expectedCount, @"Should be 13 cards");
    XCTAssertEqual([diamonds count], expectedCount, @"Should be 13 cards");
    XCTAssertEqual([spades count], expectedCount, @"Should be 13 cards");
    XCTAssertEqual([clubs count], expectedCount, @"Should be 13 cards");
}

- (void)testPlayingCardDeckAnswersPlayingCards {
    PlayingCardDeck *deck = [[PlayingCardDeck alloc] init];
    id card = [deck drawRandomCard];
    XCTAssertTrue([card isKindOfClass:[PlayingCard class]], @"We should be drawing instances of PlayingCard from this deck.");
}



@end
