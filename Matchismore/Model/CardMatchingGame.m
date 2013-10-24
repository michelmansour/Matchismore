//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) NSUInteger matchSize;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) BOOL flipDownOnMismatch;
@property (strong, nonatomic, readwrite) Card *lastFlipCard;
@property (strong, nonatomic, readwrite) NSMutableArray *lastCardsChecked;
@property (nonatomic, readwrite) BOOL lastFlipWasMatchCheck;
@property (nonatomic, readwrite) BOOL lastFlipWasMatch;
@property (nonatomic, readwrite) int lastFlipScore;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck withMatchSetSize:(NSUInteger)matchSize withFlipCost:(NSUInteger)flipCost withMatchBonus:(NSUInteger)matchBonus withMismatchPenalty:(NSUInteger)mismatchPenalty flipDownOnMismatch:(BOOL)flipDownOnMismatch {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.deck = deck;
        self.matchSize = matchSize;
        self.flipCost = flipCost;
        self.matchBonus = matchBonus;
        self.mismatchPenalty = mismatchPenalty;
        self.flipDownOnMismatch = flipDownOnMismatch;
    }
    
    return self;
}

- (NSUInteger)numberOfCardsInPlay {
    return [self.cards count];
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSArray *)moreCards:(NSUInteger)count {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [result addObject:card];
        } else {
            break;
        }
    }
    [self.cards addObjectsFromArray:result];
    return result;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.lastFlipScore = 0;
    self.lastFlipCard = nil;
    self.lastFlipWasMatch = NO;
    self.lastFlipWasMatchCheck = NO;
    self.lastCardsChecked = [[NSMutableArray alloc] init];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [cardsToMatch addObject:otherCard];
                }
            }
            if ([cardsToMatch count] + 1 == self.matchSize) {
                int matchScore = [card match:cardsToMatch];
                self.lastFlipWasMatchCheck = YES;
                self.lastCardsChecked = cardsToMatch;
                if (matchScore > 0) {
                    for (Card *matchCard in cardsToMatch) {
                        matchCard.unplayable = YES;
                    }
                    card.unplayable = YES;
                    self.lastFlipScore = matchScore * self.matchBonus;
                    self.lastFlipWasMatch = YES;
                } else {
                    for (Card *matchCard in cardsToMatch) {
                        matchCard.faceUp = NO;
                    }
                    self.lastFlipScore = -self.mismatchPenalty;
                }
            }
            self.score += self.lastFlipScore - self.flipCost;
        }
        self.lastFlipCard = card;
        if (self.flipDownOnMismatch && self.lastFlipWasMatchCheck && !self.lastFlipWasMatch) {
            card.faceUp = NO;
        } else {
            card.faceUp = !card.isFaceUp;
        }
    }
}

- (void)removeCardAtIndex:(NSUInteger)index {
    [self.cards removeObjectAtIndex:index];
}

@end
