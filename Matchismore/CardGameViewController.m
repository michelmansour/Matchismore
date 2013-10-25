//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic, readwrite) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self deckStartSize] usingDeck:[self deckToPlayWith] withMatchSetSize:self.matchSetSize withFlipCost:self.flipCost withMatchBonus:4 withMismatchPenalty:2 flipDownOnMismatch:self.flipDownOnMismatch];
    }
    return _game;
}

- (GameResult *)gameResult {
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] initForGame:[self gameName]];
    }
    return _gameResult;
}

- (NSString *)gameName { return nil; } // abstract
- (NSUInteger)deckStartSize { return 0; } // abstract
- (Deck *)deckToPlayWith { return nil; } // abstract
- (NSUInteger)matchSetSizeToPlayWith { return 0; } // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate { /* abstract */ }

- (NSAttributedString *)displayStringForCard:(Card *)card {
    return [[NSAttributedString alloc] initWithString:card.contents];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.game numberOfCardsInPlay];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

- (void)updateUI {
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        if (self.removeUnplayableCards) {
            for (int i = [self.game numberOfCardsInPlay] - 1; i >= 0; i--) {
                Card *card = [self.game cardAtIndex:i];
                if ([card isUnplayable]) {
                    [self.game removeCardAtIndex:i];
                    [self.cardCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                }
            }
        }
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
}

- (void)requestMoreCards:(NSUInteger)count {
    NSUInteger curNumCards = [self.game numberOfCardsInPlay];
    NSArray *cards = [self.game moreCards:count];
    if ([cards count] > 0) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int i = 0; i < [cards count]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:curNumCards + i inSection:0]];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
        [self.cardCollectionView scrollToItemAtIndexPath:[indexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more cards"
                                                        message:@"There are no more cards in the deck"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setupGame { /* abstract */ }

- (void)dealNewGame {
    self.game = nil;
    self.gameResult = nil;
    [self.cardCollectionView reloadData];
    [self setupGame];
    [self updateUI];
}

@end
