//
//  ViewController.m
//  DDTestDemo
//
//  Created by admin on 2018/5/7.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import "ViewController.h"
#import "DDDeviceDetection.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <LocalAuthentication/LocalAuthentication.h>

#import "DerekCameraViewController.h"


@interface ViewController ()
<CBCentralManagerDelegate,
CLLocationManagerDelegate,
DerekCameraDelegate>


//蓝牙
@property (nonatomic, strong) CBCentralManager *centralManager;

//指纹
@property (nonatomic, copy) NSString *localizedReason;


/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationM;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"wifiEnabled-----::::%@",@([DDDeviceDetection isWiFiEnabled]));
    //NSLog(@"wifiConnect----::::%@",@([DDDeviceDetection isWIFIConnection]));
    
    //self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // 指南针
    //[self.locationM startUpdatingHeading];
    
    //指纹
    //[self OnTouchIDBtn:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // 在初始化 CBCentralManager 的时候会打开设备，只有当设备正确打开后才能使用
    
    switch (central.state) {
            
        case CBManagerStatePoweredOn:        // 蓝牙已打开，开始扫描外设
            
            NSLog(@"蓝牙已打开，开始扫描外设");
            
            // 开始扫描周围的设备，自定义方法
            //[self sacnNearPerpherals];
            
            break;
            
        case CBManagerStateUnsupported:
            
            NSLog(@"您的设备不支持蓝牙或蓝牙 4.0");
            
            break;
            
        case CBManagerStateUnauthorized:
            
            NSLog(@"未授权打开蓝牙");
            
            break;
            
        case CBManagerStatePoweredOff:       // 蓝牙未打开，系统会自动提示打开，所以不用自行提示
            NSLog(@"蓝牙未打开:::");
        default:
            break;
    }
}



#pragma mark -  指纹识别

-(void)OnTouchIDBtn:(UIButton *)sender {
    //判断设备是否支持Touch ID
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        [self createAlterView:@"不支持指纹识别"];
        return;
    }else{
        LAContext *ctx = [[LAContext alloc] init];
        //设置 输入密码 按钮的标题
        ctx.localizedFallbackTitle = @"输入密码";
        //设置 取消 按钮的标题 iOS10之后
        //ctx.localizedCancelTitle = @"取消";
        //检测指纹数据库更改 验证成功后返回一个NSData对象，否则返回nil
        //ctx.evaluatedPolicyDomainState;
        // 这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，再次进入支付宝是不需要录入指纹的。因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟
        //ctx.touchIDAuthenticationAllowableReuseDuration = 5;
        NSError * error;
        
        _localizedReason = @"检测指纹识别功能";
        // 判断设备是否支持指纹识别
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            
            // 验证指纹是否匹配，需要弹出输入密码的弹框的话：iOS9之后用 LAPolicyDeviceOwnerAuthentication ；    iOS9之前用LAPolicyDeviceOwnerAuthenticationWithBiometrics
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:_localizedReason reply:^(BOOL success, NSError * error) {
                
                if (success) {
                    [self createAlterView:@"指纹验证成功"];
                    
                }else{
                    // 错误码 error.code
                    NSLog(@"指纹识别错误描述 %@",error.description);
                    // -1: 连续三次指纹识别错误
                    // -2: 在TouchID对话框中点击了取消按钮
                    // -3: 在TouchID对话框中点击了输入密码按钮
                    // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                    // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    NSString * message;
                    switch (error.code) {
                        case -1://LAErrorAuthenticationFailed
                            message = @"已经连续三次指纹识别错误了，请输入密码验证";
                            break;
                        case -2:
                            message = @"在TouchID对话框中点击了取消按钮";
                            return ;
                            break;
                        case -3:
                            message = @"在TouchID对话框中点击了输入密码按钮";
                            NSLog(@"0------------");
                            break;
                        case -4:
                            message = @"TouchID对话框被系统取消，例如按下Home或者电源键或者弹出密码框";
                            break;
                        case -8:
                            message = @"TouchID已经被锁定,请前往设置界面重新启用";
                            break;
                        default:
                            break;
                    }
                    [self createAlterView:message];
                }
                
                
            }];
  
            
        }else{
            if (error.code == -8) {
                [self createAlterView:@"由于五次识别错误TouchID已经被锁定,请前往设置界面重新启用"];
            }else{
                [self createAlterView:@"TouchID没有设置指纹,请前往设置"];
            }
        }
    }
}


- (void)createAlterView:(NSString *)message{
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:vc animated:NO completion:^(void){
        [NSThread sleepForTimeInterval:1.0];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
}




#pragma mark - 指南针

-(CLLocationManager *)locationM {
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
    }
    return _locationM;
    
}

#pragma mark -CLLocationManagerDelegate

// 已经更新到用户设备朝向时调用
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // magneticHeading : 距离磁北方向的角度 // trueHeading : 真北
    // headingAccuracy : 如果是负数,代表当前设备朝向不可用
    NSLog(@":::::::%@",@(newHeading.headingAccuracy));
    if (newHeading.headingAccuracy < 0) {
        NSLog(@"指南针异常");
    } else {
        NSLog(@"指南针正常");
    }
    
    // 角度 CLLocationDirection angle = newHeading.magneticHeading; // 角度-> 弧度 double radius = angle / 180.0 * M_PI; // 反向旋转图片(弧度)
    //    [UIView animateWithDuration:0.5 animations:^{
    //        self.compassView.transform = CGAffineTransformMakeRotation(-radius);
    //    }]; }
    
}

#pragma mark - 相机照相

- (IBAction)takePhotos:(UIButton *)sender {
    DerekCameraViewController *vc = [[DerekCameraViewController alloc] init];
    vc.delegate = self;
    vc.isFrontCamera = NO;
    vc.isAutoTakePicture = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - DerekCameraDelegate

- (void)ay_getImage:(UIImage *)image {
    //self.bgImgView.image = image;
    NSLog(@"image::::%@",image);
}

- (void)ay_failure {
    NSLog(@"摄像头失败");
}

@end
