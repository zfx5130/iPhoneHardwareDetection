//
//  YMPowerDashboard.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationBlock)(CGFloat value);

@interface YMPowerDashboard : UIView

@property (nonatomic, copy) AnimationBlock animationBlock;

@property (strong, nonatomic) CADisplayLink *displayLink;

- (void)setProgressAnimationInterval:(NSInteger)animationInterval
                                from:(CGFloat)startProgress
                                  to:(CGFloat)endProgress;

@end
