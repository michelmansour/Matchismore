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

@interface CardGameViewController : UIViewController

- (NSString *)gameName; // abstract
- (NSAttributedString *)displayStringForCard:(Card *)card; // abstract
- (void)decorateCardButton:(UIButton *)cardButton fromCard:(Card *)card; // abstract
- (NSUInteger)deckStartSize; // abstract
- (void)setupGame;
- (Deck *)deckToPlayWith; // abstract
- (NSUInteger)matchSetSizeToPlayWith; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; // abstract

@end
