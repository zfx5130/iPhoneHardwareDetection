//
//  YMPowerDashboard.h
//  CircleAnimationDemo
//
//  Created by dev on 15/12/22.
//  Copyright © 2015年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CheckAnimationTypeTouchId,
    CheckAnimationTypeWIFi,
    CheckAnimationTypeBluetooth,
    CheckAnimationTypeSound,
    CheckAnimationTypeResponse,
    CheckAnimationTypeZhiNanZhen,
    CheckAnimationTypeCamera,
    CheckAnimationTypeCallPhone

} CheckAnimationType;

typedef void(^AnimationBlock)(CGFloat value);

@interface YMPowerDashboard : UIView

@property (nonatomic, copy) AnimationBlock animationBlock;

- (void)setProgressAnimationInterval:(NSInteger)animationInterval
                                from:(CGFloat)startProgress
                                  to:(CGFloat)endProgress;

//暂停
- (void)pauseAnimation;

//取消暂停
- (void)canclePauseAnimation;

@end
