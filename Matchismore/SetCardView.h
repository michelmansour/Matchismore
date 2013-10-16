//
//  SetCardView.h
//  Matchismore
//
//  Created by Michel Mansour on 10/10/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;

@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) BOOL drawBorder;

@end
