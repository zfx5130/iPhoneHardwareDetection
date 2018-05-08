//
//  HardwareDectionView.m
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import "HardwareDectionView.h"

@implementation HardwareDectionView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                      owner:self
                                    options:nil];
        self.aView.frame = frame;
        [self addSubview:self.aView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
