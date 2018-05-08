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
#import "HardwareDectionTableViewCell.h"
#import "HardwareDectetionViewController.h"

@interface HardwareDectetionViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YMPowerDashboard *circleAnimationView;

@property (strong, nonatomic) HardwareDectionView *tableHeadView;

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
    [self setupAddHeadAnimation];
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

- (void)setupAddHeadAnimation {
    self.circleAnimationView =
    [[YMPowerDashboard alloc] initWithFrame:self.tableHeadView.headHardwareAniHolderView.bounds];
    self.circleAnimationView.animationInterval = 1.5f;
    [self.circleAnimationView setPercent:0.65f
                                animated:YES];
    [self.tableHeadView.headHardwareAniHolderView addSubview:self.circleAnimationView];
    
    const NSString *deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
    self.tableHeadView.phoneTitleLabel.text = [NSString stringWithFormat:@"%@",deviceName];
    self.tableHeadView.spaceSizeLabel.text = [NSString stringWithFormat:@"%@",[self getMemorySize]];
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

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HardwareDectionTableViewCell * homeListCell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HardwareDectionTableViewCell class])];
    homeListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return homeListCell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath::::%@", @(indexPath.row));
}

#pragma mark - Handlers

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
