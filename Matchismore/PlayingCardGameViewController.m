//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()
@property (nonatomic) NSUInteger deckStartSize;
@property (weak, nonatomic) IBOutlet UITextView *descText;
@end

#define DEFAULT_NUM_CARDS_IN_PLAY 22

@implementation PlayingCardGameViewController

- (NSString *)gameName {
    return @"Match";
}

- (void)setupGame {
    // nothing yet...
}

- (BOOL)removeUnplayableCards {
    return NO;
}

- (NSUInteger)deckStartSize {
    if (_deckStartSize) {
        return _deckStartSize;
    }
    return DEFAULT_NUM_CARDS_IN_PLAY;
}

- (Deck *)deckToPlayWith {
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)matchSetSize {
    return 2;
}

- (NSUInteger)flipCost {
    return 1;
}

- (NSAttributedString *)displayStringForCard:(Card *)card {
    return [[NSAttributedString alloc] initWithString:card.contents];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]] &&
        [card isKindOfClass:[PlayingCard class]]) {
        PlayingCardCollectionViewCell *pccvc = (PlayingCardCollectionViewCell *)cell;
        PlayingCard *playingCard = (PlayingCard *)card;
        if (animate && pccvc.playingCardView.faceUp != card.isFaceUp) {
            [UIView transitionWithView:pccvc.playingCardView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                pccvc.playingCardView.rank = playingCard.rank;
                                pccvc.playingCardView.suit = playingCard.suit;
                                pccvc.playingCardView.faceUp = playingCard.isFaceUp;
                                pccvc.playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
                            }
                            completion:NULL];
        } else {
            pccvc.playingCardView.rank = playingCard.rank;
            pccvc.playingCardView.suit = playingCard.suit;
            pccvc.playingCardView.faceUp = playingCard.isFaceUp;
            pccvc.playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}


- (NSAttributedString *)joinAttrStrings:(NSArray *)strs withString:(NSString *)delim {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *delimiter = [[NSAttributedString alloc] initWithString:delim];
    for (id item in strs) {
        if ([item isKindOfClass:[NSAttributedString class]]) {
            NSAttributedString *str = (NSAttributedString *)item;
            if (result.length > 0) {
                [result appendAttributedString:delimiter];
            }
            [result appendAttributedString:str];
        }
    }
    
    return result;
}

- (void)updateUI {
    [super updateUI];
    
    // set the last flip description
    NSMutableAttributedString *descStr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.game.lastFlipWasMatchCheck) {
        NSMutableArray *cardContents = [[NSMutableArray alloc] init];
        [cardContents addObject:[self displayStringForCard:self.game.lastFlipCard]];
        for (id item in self.game.lastCardsChecked) {
            if ([item isKindOfClass:[Card class]]) {
                Card *matchCard = (Card *)item;
                [cardContents addObject:[self displayStringForCard:matchCard]];
            }
        }
        if (self.game.lastFlipWasMatch) {
            [descStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
            [descStr appendAttributedString:[self joinAttrStrings:cardContents withString:@"&"]];
            [descStr appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@" for %d points", self.game.lastFlipScore]]];
        } else {
            [descStr appendAttributedString:[self joinAttrStrings:cardContents withString:@"&"]];
            [descStr appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@" don't match! %d point penalty!", -1 * self.game.lastFlipScore]]];
        }
    } else if (self.game.lastFlipCard) {
        if (self.game.lastFlipCard.isFaceUp) {
            [descStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
            [descStr appendAttributedString:[self displayStringForCard:self.game.lastFlipCard]];
        } else {
            [descStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped down "]];
            [descStr appendAttributedString:[self displayStringForCard:self.game.lastFlipCard]];
        }
    }
    self.descText.attributedText = descStr;
}

@end
