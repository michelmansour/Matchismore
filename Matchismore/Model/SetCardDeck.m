//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init {
    self = [super init];
    
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++){
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.shading = shading;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
