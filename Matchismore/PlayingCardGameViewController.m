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
@end

#define DEFAULT_NUM_CARDS_IN_PLAY 22

@implementation PlayingCardGameViewController

- (NSString *)gameName {
    return @"Match";
}

- (void)setupGame {
    // nothing yet...
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

- (NSUInteger)matchSetSizeToPlayWith {
    return 2;
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

@end
