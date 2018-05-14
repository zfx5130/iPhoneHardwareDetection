//
//  DerekCameraViewController.h
//  DIYCamera_demo
//
//  Created by Derek on 18/01/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DerekCameraDelegate <NSObject>

- (void)ay_getImage:(UIImage *)image;

- (void)ay_failure;

@end

@interface DerekCameraViewController : UIViewController

@property (nonatomic, weak) id <DerekCameraDelegate> delegate;

//是否是前置摄像头，默认NO
@property (nonatomic, assign) BOOL isFrontCamera;

//是否自动拍照，默认NO,默认3秒
@property (nonatomic, assign) BOOL isAutoTakePicture;

@end
