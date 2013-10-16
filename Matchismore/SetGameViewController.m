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
        sccvc.setCardView.drawBorder = YES;
    }
}

- (void)updateUI {
    [super updateUI];
    
    if (self.game.lastFlipWasMatchCheck) {
        
    } else if (self.game.lastFlipCard) {
        if ([self.game.lastFlipCard isKindOfClass:[SetCard class]]) {
            SetCard *card = (SetCard *)self.game.lastFlipCard;
            SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(0, 0, self.descriptionView.bounds.size.width / 2, self.descriptionView.bounds.size.height / 2)];
            cardView.number = card.number;
            cardView.shape = card.shape;
            cardView.color = card.color;
            cardView.shading = card.shading;
            cardView.selected = NO;
            cardView.drawBorder = NO;
            [self.descriptionView addSubview:cardView];
        }
    }
}

- (IBAction)threeMoreCards:(UIButton *)sender {
    [self requestMoreCards:SET_MORE_CARDS];
}

@end
