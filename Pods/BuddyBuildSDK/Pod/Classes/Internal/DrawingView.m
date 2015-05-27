//
//  DrawingView.m
//  WhatAnIdiot
//
//  Created by Chris on 2015-01-10.
//  Copyright (c) 2015 VanCity. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView
{
    float initialX;
    float initialY;
    float currentX;
    float currentY;
    bool hasRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
    }
    return self;
}

- (void)drawRect:(CGRect)rect // (5)
{
//    [[UIColor blackColor] setStroke];

    if (hasRect) {
        float x = initialX < currentX ? initialX : currentX;
        float y = initialY < currentY ? initialY : currentY;
        CGRect rectangle = CGRectMake(x, y, fabsf(currentX-initialX), fabsf(currentY-initialY));
        CGRect innerRectangle = CGRectMake(x + 2, y + 2, fabsf(currentX-initialX) - 4, fabsf(currentY-initialY) - 4);

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.2);
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(context, 2);
        CGContextFillRect(context, rectangle);
        CGContextStrokeRect(context, rectangle);

        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
        CGContextStrokeRect(context, innerRectangle);
    }

}

- (void)reset {
    hasRect = false;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    hasRect = YES;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    initialX = p.x;
    initialY = p.y;

    [self.parent hideChrome];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    currentX = p.x;
    currentY = p.y;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];

    float width = fabsf(initialX - currentX);
    float height = fabsf(initialY - currentY);

    if (width < 30 && height < 30) {
        hasRect = false;
        [self setNeedsDisplay];
    }
    else {
        [self.parent showTextbox];
    }

    [self.parent showChrome];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
