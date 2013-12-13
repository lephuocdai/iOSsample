//
//  CardGameViewController.m
//  Matchismo
//
//  Created by レー フックダイ on 12/11/13.
//  Copyright (c) 2013 lephuocdai. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic, strong) Deck *deck;
@end

@implementation CardGameViewController

- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"%d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"google_active"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"picasa_dark"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"A♣︎" forState:UIControlStateNormal];
    }
    self.flipCount++;
}


@end
