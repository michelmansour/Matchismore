//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (strong, nonatomic, readonly) Card *lastFlipCard;
@property (strong, nonatomic, readonly) NSArray *lastCardsChecked;
@property (nonatomic, readonly) BOOL lastFlipWasMatchCheck;
@property (nonatomic, readonly) BOOL lastFlipWasMatch;
@property (nonatomic, readonly) int lastFlipScore;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck withMatchSetSize:(NSUInteger)matchSize withFlipCost:(NSUInteger)flipCost withMatchBonus:(NSUInteger)matchBonus withMismatchPenalty:(NSUInteger)mismatchPenalty;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfCardsInPlay;

@end