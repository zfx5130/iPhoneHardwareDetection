//
//  CricleAnimationView.m
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import "YMPowerDashboard.h"

static const CGFloat kDefaultCircleWidth = 1.0f;
static const CGFloat kDefaultCircleHeight = 6.0f;
static const CGFloat kDefaultCircleCount = 40.0f;
static const CGFloat kDefalutBatteryLabelFontSize = 30.0f;
static const CGFloat kDefalutSubTitleLabelFontSize = 16.0f;

@interface YMPowerDashboard ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAReplicatorLayer *replicatorOtherLayer;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIView *circleView;
@property (assign, nonatomic) CGFloat startValue;
@property (assign, nonatomic) CGFloat endValue;
@property (assign, nonatomic) CGFloat currentValue;
@property (assign, nonatomic) CFTimeInterval beginTime;

@end

@implementation YMPowerDashboard

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addWhiteReplicatorLayer];
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

- (void)addWhiteReplicatorLayer {
    [self addReplicatorLayerWith:self.replicatorLayer
                     circleCount:kDefaultCircleCount * 2
                           alpha:0.6f
                        duration:3.0f];
}

- (void)addReplicatorLayerWith:(CAReplicatorLayer *)replicatorLayer
                   circleCount:(NSUInteger)circleCount
                         alpha:(CGFloat)alpha
                      duration:(CGFloat)duration {
    
    replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:replicatorLayer];
    CALayer *circle = [CALayer layer];
    circle.bounds = CGRectMake(0.0f, 0.0f, kDefaultCircleWidth, kDefaultCircleHeight);
    circle.position = CGPointMake(CGRectGetWidth(self.frame) * 0.5f , 3);
    circle.backgroundColor = [UIColor colorWithRed:248.0f / 255.0f green:181.0f / 255.0f blue:0.0f alpha:1.0f].CGColor;
    [replicatorLayer addSublayer:circle];
    replicatorLayer.instanceCount = circleCount;
    CGFloat angle = (2 * M_PI) / (circleCount);
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
}

- (void)setupViews {
    self.animationInterval = 1.0f;
    self.backgroundColor = [UIColor clearColor];
    [self setupBgColorView];
    [self setupBatteryLabel];
    [self setupSubTitleLabel];
}

- (void)setupBgColorView {
    UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 120, 120)];
    bgColorView.backgroundColor = [UIColor colorWithRed:248.0f / 255.0f green:181.0f / 255.0f blue:0.0f alpha:1.0f];
    bgColorView.layer.cornerRadius = 60;
    [self addSubview:bgColorView];
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

- (void)startDisplayLink {
    [self stopDisplayLink];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
    self.beginTime = CACurrentMediaTime();
}

- (void)updatePower {
    CGFloat percent =
    (CACurrentMediaTime() - self.beginTime) / self.animationInterval / fabs(self.endValue - self.startValue);
    percent = percent > 1 ? 1.0f : percent;
    percent = percent < 0 ? 0.0f : percent;
    self.currentValue = self.startValue + (self.endValue - self.startValue) * percent;
    if (self.currentValue == self.endValue) {
        self.startValue = self.endValue;
        [self stopDisplayLink];
    }
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Public 

- (void)setPercent:(CGFloat)percent
          animated:(BOOL)animated {
    self.endValue = percent;
    if (animated) {
        [self startDisplayLink];
    } else {
        self.currentValue = percent;
        self.startValue = self.endValue;
    }
}

#pragma mark - Lifecycle

- (void)drawRect:(CGRect)rect {
    
    /****************方法2,画细线和线头的圆(少渐变色) ***/
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat centerX = width * 0.5f;
    CGFloat centerY = height * 0.5f;
    CGFloat lineWidth = 5.0f;
    CGFloat radius = width * 0.5f - lineWidth * 0.5f - 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //粗线
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 248.0f / 255.0f, 181.0f / 255.0f, 0.0f, 1.0f);
    CGContextSetLineWidth(context, 6);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGMutablePathRef pathM = CGPathCreateMutable();
    CGPathAddArc(pathM, NULL, centerX, centerY, radius, 3 * M_PI / 2, 3 * M_PI / 2 + 2 * M_PI * self.currentValue, NO);
    CGContextAddPath(context, pathM);
    CGContextStrokePath(context);
    
}

@end
