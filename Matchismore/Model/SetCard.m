//
//  SetCard.m
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents {
    return [NSString stringWithFormat:@"%d;%@;%@;%@", self.number, self.shape, self.color, self.shading];
}

@synthesize shape = _shape;

- (NSString *)shape {
    return _shape ? _shape : @"?";
}

- (void)setShape:(NSString *)shape {
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}

@synthesize color = _color;

- (NSString *)color {
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color {
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

@synthesize shading = _shading;

- (NSString *)shading {
    return _shading ? _shading : @"?";
}

- (void)setShading:(NSString *)shading {
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (void)setNumber:(NSUInteger)number {
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

+ (NSArray *)validShapes {
    return @[@"diamond", @"oval", @"squiggle"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

+ (NSArray *)validShadings {    
    return @[@"solid", @"open", @"striped"];
}

+ (NSUInteger)maxNumber {
    return 3;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    NSMutableArray *shapes = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    NSMutableArray *shadings = [[NSMutableArray alloc] init];
    NSMutableArray *numbers = [[NSMutableArray alloc] init];

    [shapes addObject:self.shape];
    [colors addObject:self.color];
    [shadings addObject:self.shading];
    [numbers addObject:@(self.number)];
    
    for (id item in otherCards) {
        if ([item isMemberOfClass:[SetCard class]]) {
            SetCard *card = (SetCard *)item;
            if (![shapes containsObject:card.shape]) {
                [shapes addObject:card.shape];
            }
            if (![colors containsObject:card.color]) {
                [colors addObject:card.color];
            }
            if (![shadings containsObject:card.shading]) {
                [shadings addObject:card.shading];
            }
            if (![numbers containsObject:@(card.number)]) {
                [numbers addObject:@(card.number)];
            }
        }
    }
    
    if (([shapes count] == 1 || [shapes count] == 3) &&
        ([colors count] == 1 || [colors count] == 3) &&
        ([shadings count] == 1 || [shadings count] == 3) &&
        ([numbers count] == 1 || [numbers count] == 3)) {
        score = 4;
    }
    
    return score;
}

@end
