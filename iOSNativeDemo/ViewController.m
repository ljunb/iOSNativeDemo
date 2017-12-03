//
//  ViewController.m
//  iOSNativeDemo
//
//  Created by CookieJ on 2017/11/29.
//  Copyright © 2017年 ljunb. All rights reserved.
//

#import "ViewController.h"
#import "RNViewController.h"
#import "RNModuleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    UIButton *navigateToA = [UIButton buttonWithType:UIButtonTypeSystem];
    navigateToA.frame = CGRectMake(0, 0, 150, 30);
    navigateToA.center = self.view.center;
    [navigateToA setTitle:@"进入活动页面A" forState:UIControlStateNormal];
    [navigateToA addTarget:self action:@selector(handleNavigate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigateToA];
    
    UIButton *navigateToB = [UIButton buttonWithType:UIButtonTypeSystem];
    navigateToB.frame = CGRectMake(0, 0, 150, 30);
    navigateToB.center = CGPointMake(CGRectGetMidX(navigateToA.frame), CGRectGetMaxY(navigateToA.frame) + 20);
    [navigateToB setTitle:@"进入活动页面B" forState:UIControlStateNormal];
    [navigateToB addTarget:self action:@selector(handleNavigate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigateToB];
    
    UIButton *navigateToC = [UIButton buttonWithType:UIButtonTypeSystem];
    navigateToC.frame = CGRectMake(0, 0, 150, 30);
    navigateToC.center = CGPointMake(CGRectGetMidX(navigateToB.frame), CGRectGetMaxY(navigateToB.frame) + 20);
    [navigateToC setTitle:@"进入活动页面C" forState:UIControlStateNormal];
    [navigateToC addTarget:self action:@selector(handleModuleNavigate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigateToC];
    
    UIButton *navigateToD = [UIButton buttonWithType:UIButtonTypeSystem];
    navigateToD.frame = CGRectMake(0, 0, 150, 30);
    navigateToD.center = CGPointMake(CGRectGetMidX(navigateToC.frame), CGRectGetMaxY(navigateToC.frame) + 20);
    [navigateToD setTitle:@"进入活动页面D" forState:UIControlStateNormal];
    [navigateToD addTarget:self action:@selector(handleModuleNavigate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigateToD];
}

- (void)handleNavigate:(UIButton *)sender {
    NSString *pageName =[sender.titleLabel.text hasSuffix:@"A"] ? @"PageA" : @"PageB";
    RNViewController *rnVC = [[RNViewController alloc] initWithPageName:pageName];
    [self.navigationController pushViewController:rnVC animated:YES];
}

- (void)handleModuleNavigate:(UIButton *)sender {
     NSString *pageName =[sender.titleLabel.text hasSuffix:@"C"] ? @"PageC" : @"PageD";
    RNModuleViewController *rnVC = [[RNModuleViewController alloc] initWithPageName:pageName];
    [self.navigationController pushViewController:rnVC animated:YES];
}

@end
