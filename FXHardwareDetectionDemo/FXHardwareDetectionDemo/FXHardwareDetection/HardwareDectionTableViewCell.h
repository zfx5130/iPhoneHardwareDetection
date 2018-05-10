//
//  HardwareDectionTableViewCell.h
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HardwareDectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;

@property (weak, nonatomic) IBOutlet UILabel *descStatusLabel;


@end
