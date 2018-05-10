//
//  HardwareDectionView.h
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HardwareDectionView : UIView

@property (strong, nonatomic) IBOutlet UIView *aView;

@property (weak, nonatomic) IBOutlet UIView *headHardwareAniHolderView;

@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *spaceSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *detectionHareDectionLabel;

@end
