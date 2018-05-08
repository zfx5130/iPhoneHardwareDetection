//
//  HardwareDectetionViewController.m
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import "HardwareDectetionViewController.h"

@interface HardwareDectetionViewController ()

@end

@implementation HardwareDectetionViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupBarButtonItem {
    self.title = @"硬件测试";
    UIBarButtonItem *leftBarItem  =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

#pragma mark - Handlers

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
