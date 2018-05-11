//
//  CricleAnimationView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "YMPowerDashboard.h"


#define LineWidth 5.f
#define Space 7.f
#define Yellow [UIColor colorWithRed:0.9725 green:0.7412 blue:0.1725 alpha:1]

static const CGFloat kDefalutBatteryLabelFontSize = 30.0f;
static const CGFloat kDefalutSubTitleLabelFontSize = 16.0f;

@interface YMPowerDashboard ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorOtherLayer;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIView *circleView;
@property (assign, nonatomic) CGFloat currentValue;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic) NSInteger animationInterval;
@property (assign, nonatomic) BOOL isFirstDraw;
@property (assign, nonatomic) CGFloat startProgress;
@property (assign, nonatomic) CGFloat endProgress;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) CGFloat currentProgress;


@end

@implementation YMPowerDashboard

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setters

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    self.batteryLabel.text = [NSString stringWithFormat:@"%d%%", (int)(currentValue * 100)];
    [self setNeedsDisplay];
}

#pragma mark - Getters

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(updatePower)];
    }
    return _displayLink;
}

#pragma mark - Private

- (void)setupViews {
    self.animationInterval = 1.0f;
    self.backgroundColor = [UIColor clearColor];
    [self setupBatteryLabel];
    [self setupSubTitleLabel];
}

- (void)setupBatteryLabel {
    self.batteryLabel = [[UILabel alloc] init];
    self.batteryLabel.font = [UIFont boldSystemFontOfSize:kDefalutBatteryLabelFontSize];
    self.batteryLabel.textAlignment = NSTextAlignmentCenter;
    self.batteryLabel.textColor = [UIColor whiteColor];
    self.batteryLabel.frame = CGRectMake((self.frame.size.width - 150) / 2 , 30, 150, 50);
    [self addSubview:self.batteryLabel];
}

- (void)setupSubTitleLabel {
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.textColor = [UIColor colorWithWhite:1.0f
                                                     alpha:1.0f];
    self.subTitleLabel.font = [UIFont systemFontOfSize:kDefalutSubTitleLabelFontSize];
    self.subTitleLabel.frame = CGRectMake(0, 65, 150, 50);
    self.subTitleLabel.text = @"检测进度";
    [self addSubview:self.subTitleLabel];
}

- (void)updatePower {
    CGFloat percent = self.currentProgress;
    double y = 2 +  (arc4random() % 6);
    self.currentProgress = self.currentProgress + y / 1000;
    percent = percent > 1 ? 1.0f : percent;
    percent = percent < 0 ? 0.0f : percent;

    self.currentValue = self.startProgress + (self.endProgress - self.startProgress) * percent;
    if (self.currentValue == self.endProgress) {
        [self stopDisplayLink];
    }
    if (self.animationBlock) {
        self.animationBlock(self.currentValue);
    }
}



- (void)startDisplayLink {
    [self stopDisplayLink];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
    self.beginTime = CACurrentMediaTime();
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}



- (void)pauseAnimation {
    [self stopDisplayLink];
}

- (void)canclePauseAnimation {
    [self stopDisplayLink];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
}

#pragma mark - Public 

- (void)setProgressAnimationInterval:(NSInteger)animationInterval
                                from:(CGFloat)startProgress
                                  to:(CGFloat)endProgress {
    self.endProgress = endProgress;
    self.startProgress = startProgress;
    self.currentProgress = startProgress;
    self.animationInterval = animationInterval;
    [self startDisplayLink];
}

#pragma mark - Lifecycle

- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawProgressLine:rect];
}

- (void)drawProgressLine:(CGRect)rect {
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat centerX = width * 0.5f;
    CGFloat centerY = height * 0.5f;
    CGFloat lineWidth = 5.0f;
    CGFloat radius = width * 0.5f - lineWidth * 0.5f - 0.5;
    
    //粗线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 248.0f / 255.0f, 181.0f / 255.0f, 0.0f, 1.0f);
    CGContextSetLineWidth(context, 6);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGMutablePathRef pathM = CGPathCreateMutable();
    CGPathAddArc(pathM, NULL, centerX, centerY, radius,  3 * M_PI / 2 + 2 * M_PI * self.startProgress , 3 * M_PI / 2 + 2 * M_PI * self.currentValue, NO);
    CGContextAddPath(context, pathM);
    CGContextStrokePath(context);
}

- (void)drawBackground {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - Space - LineWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [Yellow setFill];
    [path fill];
    [self drawCircleDashed];
}

- (void)drawCircleDashed {
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) / 2.f, CGRectGetHeight(rect) / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 - LineWidth / 2;
    CGFloat endAngle = 2 * M_PI;
    CGFloat startAngle = 0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CGFloat lengths[] = { 2, 6 };
    [path setLineDash:lengths count:2 phase:0];
    [path setLineWidth:LineWidth];
    [Yellow setStroke];
    [path stroke];
}

@end
