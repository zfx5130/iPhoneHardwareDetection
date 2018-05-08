//
//  ViewController.m
//  FXHardwareDetectionDemo
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 thomas. All rights reserved.
//

#import "ViewController.h"

#import "HardwareDectetionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Handlers

- (IBAction)hardWareDetection:(UIButton *)sender {
    
    HardwareDectetionViewController *hardwareController = [[HardwareDectetionViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:hardwareController];
    [self presentViewController:navigation animated:YES completion:nil];
    
}


@end
