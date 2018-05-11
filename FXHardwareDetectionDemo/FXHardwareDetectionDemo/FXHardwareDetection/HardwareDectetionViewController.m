//
//  HardwareDectetionViewController.m
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import "YMPowerDashboard.h"
#import "HardwareDectionView.h"
#import "DeviceInfoManager.h"
#import "NetWorkInfoManager.h"
#import "HardwareDectionTableViewCell.h"
#import "HardwareDectetionViewController.h"

#define kUIColorFromRGBA(r,g,b,a)     [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

@interface HardwareDectetionViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YMPowerDashboard *circleAnimationView;

@property (strong, nonatomic) HardwareDectionView *tableHeadView;

@property (strong, nonatomic) NSMutableArray *allDectionArrays;

@property (assign, nonatomic) BOOL flag1;
@property (assign, nonatomic) BOOL flag2;
@property (assign, nonatomic) BOOL flag3;
@property (assign, nonatomic) BOOL flag4;
@property (assign, nonatomic) BOOL flag5;
@property (assign, nonatomic) BOOL flag6;
@property (assign, nonatomic) BOOL flag7;
@property (assign, nonatomic) BOOL flag8;

@end

@implementation HardwareDectetionViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderUI];
    [self requestApi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)renderUI {
    [self registerTableViewCell];
    [self setupBarButtonItem];
}

- (void)requestApi {
    [self setupCircleHeadAnimation];
    [self renderHeadInfo];
}

- (void)registerTableViewCell {
    UINib *cellNib =
    [UINib nibWithNibName:NSStringFromClass([HardwareDectionTableViewCell class])
                   bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:NSStringFromClass([HardwareDectionTableViewCell class])];
    
    self.tableHeadView =
    [[HardwareDectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 230)];
    self.tableView.tableHeaderView = self.tableHeadView;
}

- (void)setupBarButtonItem {
    self.title = @"硬件测试";
    UIBarButtonItem *leftBarItem  =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)renderHeadInfo {
    const NSString *deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
    self.tableHeadView.phoneTitleLabel.text = [NSString stringWithFormat:@"%@",deviceName];
    self.tableHeadView.spaceSizeLabel.text = [NSString stringWithFormat:@"%@",[self getMemorySize]];
}

- (void)setupCircleHeadAnimation {
    //创建动画
    self.circleAnimationView =
    [[YMPowerDashboard alloc] initWithFrame:self.tableHeadView.headHardwareAniHolderView.bounds];
    [self.tableHeadView.headHardwareAniHolderView addSubview:self.circleAnimationView];
    __block typeof(self) weakSlef = self;
    self.circleAnimationView.animationBlock = ^(CGFloat value) {
        [weakSlef setupTableViewCellAminationWithCurrentValue:value];
    };
    [self.circleAnimationView setProgressAnimationInterval:16
                                                      from:0.0
                                                        to:1.0];
}

- (NSString *)getMemorySize {
    int64_t totalDisk = [[DeviceInfoManager sharedManager] getTotalDiskSpace];
    NSString *memoryString = @"32G";
    CGFloat memoryValue = totalDisk / 1024 / 1024 / 1024.0;
    if (memoryValue <= 32) {
        memoryString = @"32G";
    } else if (memoryValue <= 64) {
        memoryString = @"64G";
    } else if (memoryValue <= 128) {
        memoryString = @"128G";
    } else if (memoryValue <= 256) {
        memoryString = @"256G";
    } else if (memoryValue <= 512) {
        memoryString = @"512G";
    } else  {
        memoryString = @"64G";
    }
    return memoryString;
}

- (void)setupTableViewCellAminationWithCurrentValue:(CGFloat)value {
    if (value <= 0.15) {
    } else if (value <= 0.23) {
        //指纹识别
        [self setupTouchIdAnimation];
    } else if (value <= 0.3) {
        //wifi检测
        [self setupWifiAnimation];
    } else if (value <= 0.45) {
        //蓝牙检测
        [self setupBluetoothAnimation];
    } else if (value <= 0.54) {
        //扬声器
        [self setupSoundAnimation];
        
    } else if (value <= 0.67) {
        //感应
        [self setupGanyingAnimation];
    } else if (value <= 0.77) {
        //指南针
        [self setupZhiNamZhenAnimation];
    } else if (value <= 0.87) {
        //相机
        [self setupCameraAnimation];
    } else if (value <= 0.95) {
        //播电话
        [self setupCallPhoneAnimation];
    }
}

- (void)setupTouchIdAnimation {
    if (!_flag1) {
        _flag1 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[0];
            touchDic[@"content"] = @"未检测";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupWifiAnimation {
    if (!_flag2) {
        _flag2 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[1];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"2";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupBluetoothAnimation {
    if (!_flag3) {
        _flag3 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.95 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[2];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"2";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupSoundAnimation {
    if (!_flag4) {
        _flag4 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[3];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"2";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupGanyingAnimation {
    if (!_flag5) {
        _flag5 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[4];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"2";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupZhiNamZhenAnimation {
    if (!_flag6) {
        _flag6 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[5];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"2";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupCameraAnimation {
    if (!_flag7) {
        _flag7 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.85 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[6];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"3";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}

- (void)setupCallPhoneAnimation {
    if (!_flag8) {
        _flag8 = YES;
        __block typeof(self) weakSelf = self;
        [self.circleAnimationView pauseAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.95 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *touchDic = self.allDectionArrays[7];
            touchDic[@"content"] = @"正常";
            touchDic[@"colorType"] = @"2";
            touchDic[@"imageType"] = @"3";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [weakSelf.circleAnimationView canclePauseAnimation];
        });
    }
}


#pragma mark - Getters && Setter

- (NSMutableArray *)allDectionArrays {
    NSString *mobilType = [[NetWorkInfoManager sharedManager] getMobileType];
    NSString *content = @"10086";
    if ([mobilType isEqualToString:@"中国移动"]) {
        content = @"10086";
    } else if ([mobilType isEqualToString:@"中国联通"]) {
        content = @"10010";
    } else if ([mobilType isEqualToString:@"中国电信"]) {
        content = @"10000";
    }
    //colorType 1:默认(r:241 g:241 b:241) 2:(r:153 g:153 b:153)
    //imageType 0:还未检测 1:未检测 2.正常 3 异常
    if (!_allDectionArrays) {
        _allDectionArrays = [@[
                               [@{
                                  @"name" : @"指纹识别",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"WIFI",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"蓝牙",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"扬声器",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"感应",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"指南针",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : @"相机",
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy],
                               [@{
                                  @"name" : [NSString stringWithFormat:@"通话(拨打%@测试通话功能)",content],
                                  @"content" : @"",
                                  @"colorType" : @"1",
                                  @"imageType" : @"0"
                                  } mutableCopy]
                               ] mutableCopy];
    }
    return _allDectionArrays;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.allDectionArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HardwareDectionTableViewCell *homeListCell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HardwareDectionTableViewCell class])];
    NSDictionary *dectionDic =  self.allDectionArrays[indexPath.row];
    homeListCell.descStatusLabel.text = [NSString stringWithFormat:@"%@",dectionDic[@"content"]];
    
    //1:默认(r:241 g:241 b:241) 2:(r:153 g:153 b:153)
    NSString *colorType = [NSString stringWithFormat:@"%@",dectionDic[@"colorType"]];
    if ([colorType isEqualToString:@"1"]) {
        homeListCell.nameLabel.textColor = kUIColorFromRGBA(153, 153, 153, 1.0);
    } else {
        homeListCell.nameLabel.textColor = kUIColorFromRGBA(51, 51, 51, 1.0);
    }
    homeListCell.nameLabel.text = [NSString stringWithFormat:@"%@",dectionDic[@"name"]];
    NSString *imageType = [NSString stringWithFormat:@"%@",dectionDic[@"imageType"]];
    //imageType 0:还未检测 1:未检测 2.正常 3 异常
    NSString *errorImage = @"button_image";
    if ([imageType isEqualToString:@"0"]) {
        errorImage = @"buttonhHH";
    } else if ([imageType isEqualToString:@"1"]) {
        errorImage = @"button_image_exception";
    } else if ([imageType isEqualToString:@"2"]) {
        errorImage = @"button_image_normal";
    } else if ([imageType isEqualToString:@"3"]) {
        errorImage = @"button_image_error";
    }
    homeListCell.errorImageView.image = [UIImage imageNamed:errorImage];
    return homeListCell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Handlers

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
