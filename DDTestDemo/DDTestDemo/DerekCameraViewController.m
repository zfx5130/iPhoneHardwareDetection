//
//  DerekCameraViewController.m
//  DIYCamera_demo
//
//  Created by Derek on 18/01/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "DerekCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kShow_Alert(_msg_)  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:_msg_ preferredStyle:UIAlertControllerStyleAlert];\
[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];\
[[[UIApplication sharedApplication].windows firstObject].rootViewController presentViewController:alertController animated:YES completion:nil];

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kSCreen_Height [UIScreen mainScreen].bounds.size.height

@interface DerekCameraViewController ()
<UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

//输入数据流
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;

//照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;

//显示相机拍摄到画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//闪光灯开关
@property (nonatomic, assign) BOOL flashFlag;

//用于是否显示
@property (nonatomic, strong) UIButton *flashBtn;

@property (nonatomic, assign) CGFloat effectiveScale;

@property (nonatomic, assign) CGFloat beginGestureScale;

@end

@implementation DerekCameraViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if ([self.delegate respondsToSelector:@selector(ay_failure)]) {
            [self.delegate ay_failure];
        }
        kShow_Alert(@"照相机不可用!");
        return;
    }
    
    [self ay_setLayoutSubviews];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        AVCaptureDeviceInput *deviceInput = [self ay_getBackCameraInput];
        if ([self.captureSession canAddInput:deviceInput]) {
            _captureDeviceInput = deviceInput;
            [self.captureSession addInput:deviceInput];
        }
    } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        AVCaptureDeviceInput *deviceInput = [self ay_getBackCameraInput];
        if ([self.captureSession canAddInput:deviceInput]) {
            _captureDeviceInput = deviceInput;
            [self.captureSession addInput:deviceInput];
        }
    } else {
        kShow_Alert(@"照相机不可用!");
    }
    if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
    [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)ay_setLayoutSubviews {
    
    self.effectiveScale = 1.0f;
    
    //焦距手势
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pin.delegate = self;
    [self.view addGestureRecognizer:pin];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCreen_Height - 50, kScreen_Width, 50)];
    bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:bottomView];
    
    
    
    UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeBtn.frame = CGRectMake(kScreen_Width / 2 - 25, 5, 50, 40);
    [takeBtn setImage:[UIImage imageNamed:@"camera_take"] forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(ay_takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:takeBtn];

    if (self.isAutoTakePicture) {
        __block typeof(self) weakSelf = self;
        double delayInSeconds = 3.0; dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC); dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //执行事件
            [weakSelf ay_takePicture:nil];
        });
    }
}


- (void)ay_takePicture:(UIButton*)sender {
    //阻断按钮响应者链,否则会造成崩溃
    self.view.userInteractionEnabled = NO;
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [captureConnection setVideoScaleAndCropFactor:self.effectiveScale];
    if (captureConnection) {
        __block typeof(self) weakSelf = self;
        [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (error) {
                return ;
            }
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf.delegate respondsToSelector:@selector(ay_getImage:)]) {
                    [weakSelf.delegate ay_getImage:image];
                }
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    weakSelf.view.userInteractionEnabled = YES;
                }];
            });
        }];
    } else {
        kShow_Alert(@"拍照失败!")
    }
}

//切换闪光灯
//- (void)ay_exchangeFlash:(UIButton*)sender{
//    _flashFlag = !_flashFlag;
//    NSError *error;
//    [self.captureDeviceInput.device lockForConfiguration:&error];
//    if (!error && [_captureDeviceInput.device hasFlash]) {
//        if (_flashFlag) {
//            [self.captureDeviceInput.device setFlashMode:AVCaptureFlashModeOn];
//        } else {
//            [self.captureDeviceInput.device setFlashMode:AVCaptureFlashModeOff];
//        }
//        [self.captureDeviceInput.device unlockForConfiguration];
//        sender.selected = _flashFlag;
//    }
//}

- (void)setIsFrontCamera:(BOOL)isFrontCamera {
    _isFrontCamera = isFrontCamera;
    AVCaptureDeviceInput *deviceInput;
    if (isFrontCamera) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            deviceInput = [self ay_getFrontCameraInput];
        } else {
            kShow_Alert(@"前置摄像头不可用");
        }
    } else {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            deviceInput = [self ay_getBackCameraInput];
        } else {
            kShow_Alert(@"后置摄像头不可用");
        }
    }
    if (deviceInput) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:_captureDeviceInput];
        if ([self.captureSession canAddInput:deviceInput]) {
            [self.captureSession addInput:deviceInput];
            _captureDeviceInput = deviceInput;
            if ([_captureDeviceInput.device hasFlash]) {
                _flashBtn.hidden = NO;
            } else {
                _flashBtn.hidden = YES;
            }
        } else {
            if ([_captureSession canAddInput:_captureDeviceInput]) {
                [_captureSession addInput:_captureDeviceInput];
            }
        }
        [self.captureSession commitConfiguration];
    }
}

/**
 获取上下文
 */
- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

/**
 获取输出流
 @return 输出流对象
 */
- (AVCaptureStillImageOutput *)captureStillImageOutput {
    if (!_captureStillImageOutput) {
        _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [_captureStillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    }
    return _captureStillImageOutput;
}


- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _captureVideoPreviewLayer.frame = self.view.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _captureVideoPreviewLayer;
}


- (AVCaptureDeviceInput*)ay_getBackCameraInput {
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self ay_getCameraWithPosition:AVCaptureDevicePositionBack] error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return deviceInput;
}

- (AVCaptureDeviceInput*)ay_getFrontCameraInput {
    NSError *error;
    AVCaptureDeviceInput *deviceInput =
    [[AVCaptureDeviceInput alloc] initWithDevice:[self ay_getCameraWithPosition:AVCaptureDevicePositionFront]
                                           error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return deviceInput;
}


- (AVCaptureDevice*)ay_getCameraWithPosition:(AVCaptureDevicePosition)devicePosition {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == devicePosition) {
            NSError *error;
            [device lockForConfiguration:&error];
            if (!error && [device hasFlash]) {
                if (_flashFlag) {
                    [device setFlashMode:AVCaptureFlashModeOn];
                }else{
                    [device setFlashMode:AVCaptureFlashModeOff];
                }
                [device unlockForConfiguration];
            }
            return device;
        }
    }
    return nil;
}


//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for (i = 0; i < numTouches; ++i) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.captureVideoPreviewLayer convertPoint:location fromLayer:self.captureVideoPreviewLayer.superlayer];
        if (![self.captureVideoPreviewLayer containsPoint:convertedLocation]) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0) {
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
