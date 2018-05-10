//
//  CircularProgressView.m
//  SellMyiPhone
//
//  Created by Vincent on 1/12/17.
//  Copyright © 2017 zssr. All rights reserved.
//

#import "CircularProgressView.h"


#define LineWidth 5.f
#define Space 7.f
#define Yellow [UIColor colorWithRed:0.9725 green:0.7412 blue:0.1725 alpha:1]

@interface CircularProgressView ()

@property (assign, nonatomic) CGFloat startProgress;

@property (assign, nonatomic) CGFloat endProgress;

@property (assign, nonatomic) NSInteger animationInterval;

@end

@implementation CircularProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgressFrom:(CGFloat)startProgress
                     to:(CGFloat)endProgress {
    if (endProgress >= 100.f) {
        endProgress = 100.f;
    }
    self.endProgress = endProgress;
    self.startProgress = startProgress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawProgressLine];
}

- (void)drawProgressLine {
    [self drawCircleDashed:NO];
}

- (void)drawBackground {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - Space - LineWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [Yellow setFill];
    [path fill];
    [self drawCircleDashed:YES];
}

- (void)drawCircleDashed:(BOOL)dash {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - LineWidth / 2;
    CGFloat endAngle = 2 * M_PI;
    CGFloat startAngle = 0;
    if (!dash) {
        startAngle = M_PI * 2 * self.startProgress / 100.f - M_PI_2;
        endAngle = M_PI * 2 * self.endProgress / 100.f - M_PI_2;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    if (dash) {
        CGFloat lengths[] = {2, 6};
        [path setLineDash:lengths count:2 phase:0];
    }
    [path setLineWidth:LineWidth];
    [Yellow setStroke];
    [path stroke];
}

@end
