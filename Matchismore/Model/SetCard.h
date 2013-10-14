//
//  SetCard.h
//  Matchismo
//
//  Created by Michel Mansour on 10/7/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)validShadings;
+ (NSUInteger)maxNumber;

@end
