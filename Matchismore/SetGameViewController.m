//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView1;
@property (weak, nonatomic) IBOutlet UIView *cardView2;
@property (weak, nonatomic) IBOutlet UIView *cardView3;
@end

#define NUM_CARDS_IN_PLAY 12
#define SET_MORE_CARDS 3

@implementation SetGameViewController

- (NSString *)gameName {
    return @"Set";
}

- (void)setupGame {
    // nothing yet...
}

- (BOOL)removeUnplayableCards {
    return YES;
}

- (NSUInteger)deckStartSize {
    return NUM_CARDS_IN_PLAY;
}

- (Deck *)deckToPlayWith {
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)matchSetSize {
    return 3;
}

- (NSUInteger)flipCost {
    return 0;
}

- (BOOL)flipDownOnMismatch {
    return YES;
}

+ (UIColor *)colorForString:(NSString *)colorStr withAlpha:(CGFloat)alpha {
    if ([colorStr isEqualToString:@"red"]) {
        return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:alpha];
    }
    if ([colorStr isEqualToString:@"green"]) {
        return [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:alpha];
    }
    if ([colorStr isEqualToString:@"purple"]) {
        return [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:alpha];
    }
    return nil;
}

- (NSAttributedString *)displayStringForCard:(Card *)card {
    if ([card isMemberOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        NSMutableAttributedString *dispStr = [[NSMutableAttributedString alloc] init];
        for (NSUInteger i = 0; i < setCard.number; i++) {
            [dispStr appendAttributedString:[[NSAttributedString alloc] initWithString:setCard.shape]];
        }
        CGFloat alpha = 1.0;
        if ([setCard.shading isEqualToString:@"striped"]) {
            alpha = 0.1;
        } else if ([setCard.shading isEqualToString:@"open"]) {
            alpha = 0.0;
        }
        [dispStr setAttributes:@{ NSForegroundColorAttributeName : [SetGameViewController colorForString:setCard.color withAlpha:alpha], NSStrokeWidthAttributeName : @-5, NSStrokeColorAttributeName : [SetGameViewController colorForString:setCard.color withAlpha:1.0]} range:NSMakeRange(0, setCard.number)];
        
        return dispStr;
    }
    
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate {
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]] &&
        [card isKindOfClass:[SetCard class]]) {
        SetCardCollectionViewCell *sccvc = (SetCardCollectionViewCell *)cell;
        SetCard *setCard = (SetCard *)card;
        
        sccvc.setCardView.number = setCard.number;
        sccvc.setCardView.shape = setCard.shape;
        sccvc.setCardView.color = setCard.color;
        sccvc.setCardView.shading = setCard.shading;
        sccvc.setCardView.selected = setCard.faceUp;
    }
}

- (void)miniView:(SetCardView *)cardView fromCard:(SetCard *)card inSuperview:(UIView *)nextCardView {
    cardView.number = card.number;
    cardView.shape = card.shape;
    cardView.color = card.color;
    cardView.shading = card.shading;
    cardView.selected = NO;

    [cardView setBackgroundColor:[UIColor clearColor]];
    cardView.center = CGPointMake(nextCardView.bounds.size.width / 2, nextCardView.bounds.size.height / 2);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_2);
    cardView.transform = rotation;
    [nextCardView addSubview:cardView];
}

- (void)updateUI {
    [super updateUI];

    [[self.cardView1 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.cardView2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.cardView3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.descriptionLabel.text = @"";
    
    if (self.game.lastFlipWasMatchCheck) {
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        if (self.game.lastFlipWasMatch) {
            self.descriptionLabel.text = [NSString stringWithFormat:@"Matched for %d points!", self.game.lastFlipScore];
        } else {
            self.descriptionLabel.text = [NSString stringWithFormat:@"Not a match! Lose %d points!", -1 * self.game.lastFlipScore];
        }

        NSMutableArray *matchedCards = [NSMutableArray arrayWithArray:self.game.lastCardsChecked];
        [matchedCards addObject:self.game.lastFlipCard];
        for (int i = 0; i < 3; i++) {
            SetCard *card = (SetCard *)matchedCards[i];
            UIView *nextCardView;
            if (i == 0) {
                nextCardView = self.cardView1;
            } else if (i == 1) {
                nextCardView = self.cardView2;
            } else {
                nextCardView = self.cardView3;
            }
            SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(nextCardView.bounds.origin.x, nextCardView.bounds.origin.y, nextCardView.bounds.size.height, nextCardView.bounds.size.width)];
            [self miniView:cardView fromCard:card inSuperview:nextCardView];
        }
    } else if (self.game.lastFlipCard) {
        if ([self.game.lastFlipCard isKindOfClass:[SetCard class]]) {
            UIView *nextCardView;
            int selectedCards = 0;
            for (int i = 0; i < [self.game numberOfCardsInPlay]; i++) {
                SetCard *card = (SetCard *)[self.game cardAtIndex:i];
                if (card.isFaceUp) {
                    selectedCards++;
                    if (selectedCards == 1) {
                        nextCardView = self.cardView1;
                    } else if (selectedCards == 2) {
                        nextCardView = self.cardView2;
                    } else {
                        nextCardView = self.cardView3;
                    }
                    SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(nextCardView.bounds.origin.x, nextCardView.bounds.origin.y, nextCardView.bounds.size.height, nextCardView.bounds.size.width)];
                    [self miniView:cardView fromCard:card inSuperview:nextCardView];
                }
            }
        }
    }
}

- (IBAction)threeMoreCards:(UIButton *)sender {
    [self requestMoreCards:SET_MORE_CARDS];
}

@end
