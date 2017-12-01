//
//  ViewController.m
//  iOSNativeDemo
//
//  Created by CookieJ on 2017/11/29.
//  Copyright © 2017年 ljunb. All rights reserved.
//

#import "ViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"iOSNativeDemo"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    self.view = rootView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
