//
//  SetCardView.m
//  Matchismore
//
//  Created by Michel Mansour on 10/10/13.
//  Copyright (c) 2013 Michel Mansour. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat shapeWidth;
@property (nonatomic) CGFloat shapeHeight;
@end

@implementation SetCardView

- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (CGFloat)shapeWidth {
    return [self width] * 0.25;
}

- (CGFloat)shapeHeight {
    return [self height] * 0.75;
}

- (void)drawDiamond:(UIBezierPath *)diamond centeredAt:(CGFloat)widthFactor {
    [diamond moveToPoint:CGPointMake(self.width * widthFactor - self.shapeWidth / 2.0, self.height / 2.0)];
    [diamond addLineToPoint:CGPointMake(self.width * widthFactor, self.height / 2.0 - self.shapeHeight / 2.0)];
    [diamond addLineToPoint:CGPointMake(self.width * widthFactor + self.shapeWidth / 2.0, self.height / 2.0)];
    [diamond addLineToPoint:CGPointMake(self.width * widthFactor, self.height / 2.0 + self.shapeHeight / 2.0)];
    [diamond closePath];
}

- (void)drawOval:(UIBezierPath *)oval centeredAt:(CGFloat)widthFactor {
    [oval moveToPoint:CGPointMake(self.width * widthFactor - self.shapeWidth / 2.0, self.height * 0.7)];
    [oval addLineToPoint:CGPointMake(self.width * widthFactor - self.shapeWidth / 2.0, self.height * 0.3)];
    [oval addArcWithCenter:CGPointMake(self.width * widthFactor, self.height * 0.3) radius:self.shapeWidth / 2.0 startAngle:M_PI endAngle:0 clockwise:YES];
    [oval addLineToPoint:CGPointMake(self.width * widthFactor + self.shapeWidth / 2.0, self.height * 0.3)];
    [oval addLineToPoint:CGPointMake(self.width * widthFactor + self.shapeWidth / 2.0, self.height * 0.7)];
    [oval addArcWithCenter:CGPointMake(self.width * widthFactor, self.height * 0.7) radius:self.shapeWidth / 2.0 startAngle:0 endAngle:M_PI clockwise:YES];
    [oval closePath];
}

- (void)drawSquiggle:(UIBezierPath *)squiggle centeredAt:(CGFloat)widthFactor {
    [squiggle moveToPoint:CGPointMake(self.width * widthFactor - self.shapeWidth / 2.0, self.height / 2.0 - self.shapeHeight / 2.0)];
    [squiggle addCurveToPoint:CGPointMake(self.width * widthFactor + self.shapeWidth / 2.0, self.height / 2.0 + self.shapeHeight / 2.0) controlPoint1:CGPointMake(self.width * widthFactor, self.height / 2.0) controlPoint2:CGPointMake(self.width * widthFactor + self.shapeWidth / 2.0, self.height / 2.0)];
//    [squiggle addCurveToPoint:CGPointMake(self.width * widthFactor - self.shapeWidth / 2.0, self.height / 2.0 - self.shapeWidth / 2.0) controlPoint1:CGPointMake(self.width * widthFactor - self.width / 2.0, self.height / 2.0) controlPoint2:CGPointMake(self.width * widthFactor, self.height / 2.0)];
//    [squiggle closePath];
}

- (void)drawShape:(UIBezierPath *)path centeredAt:(CGFloat)widthFactor {
    if ([self.shape isEqualToString:@"diamond"]) {
        [self drawDiamond:path centeredAt:widthFactor];
    } else if ([self.shape isEqualToString:@"oval"]) {
        [self drawOval:path centeredAt:widthFactor];
    } else if ([self.shape isEqualToString:@"squiggle"]) {
        [self drawSquiggle:path centeredAt:widthFactor];
    }
}

- (UIColor *)colorAsColor {
    if ([self.color isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([self.color isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([self.color isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    } else {
        return [UIColor clearColor];
    }
}

- (void)drawShapes {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (self.number == 1 || self.number == 3) {
        [self drawShape:path centeredAt:0.5];
        if (self.number == 3) {
            [self drawShape:path centeredAt:0.2];
            [self drawShape:path centeredAt:0.8];
        }
    } else if (self.number == 2) {
        [self drawShape:path centeredAt:0.35];
        [self drawShape:path centeredAt:0.65];
    }
    
    UIColor *color = [self colorAsColor];
    if ([self.shading isEqualToString:@"solid"]) {
        [color setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        [path addClip];
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        for (int i = 0; i < self.height; i += 3) {
            [stripes moveToPoint:CGPointMake(0, i)];
            [stripes addLineToPoint:CGPointMake(self.width, i)];
        }
        [color setStroke];
        stripes.lineWidth = 1.0;
        [stripes stroke];
        CGContextRestoreGState(context);
    }
    [color setStroke];
    path.lineWidth = 2.0;
    [path stroke];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:12.0];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [self drawShapes];
}


@end
