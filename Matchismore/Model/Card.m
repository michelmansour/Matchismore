//
//  Card.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (id item in otherCards) {
        if ([item isKindOfClass:[Card class]]) {
            Card *card = (Card *)item;
            if ([card.contents isEqualToString:self.contents]) {
                score = 1;
            }
        }
    }
    
    return score;
}

@end
