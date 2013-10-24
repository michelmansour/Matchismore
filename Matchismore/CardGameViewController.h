//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic, readonly) CardMatchingGame *game;
@property (nonatomic, readonly) NSUInteger matchSetSize;
@property (nonatomic, readonly) NSUInteger flipCost;
@property (nonatomic, readonly) BOOL flipDownOnMismatch;
@property (nonatomic, readonly) BOOL removeUnplayableCards;

- (NSString *)gameName; // abstract
- (NSAttributedString *)displayStringForCard:(Card *)card; // abstract
- (NSUInteger)deckStartSize; // abstract
- (void)setupGame;
- (Deck *)deckToPlayWith; // abstract
- (NSUInteger)matchSetSizeToPlayWith; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; // abstract
- (void)requestMoreCards:(NSUInteger)count;
- (void)updateUI;

@end
