//
//  RNViewController.m
//  iOSNativeDemo
//
//  Created by CookieJ on 2017/12/3.
//  Copyright © 2017年 ljunb. All rights reserved.
//

#import "RNViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

static const NSString* PAGE_NAME_KEY = @"pageName";

@interface RNViewController ()
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, strong) NSMutableDictionary *initialProperties;
@end

@implementation RNViewController

- (instancetype)initWithPageName:(NSString *)pageName {
    self = [super init];
    if (self) {
        _pageName = pageName;
        _initialProperties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.pageName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configInitialProperties];
    [self setupRootView];
}

- (void)configInitialProperties {
    // 设置pageName
    [self.initialProperties setObject:self.pageName forKey:PAGE_NAME_KEY];
    
    // 其他配置，如读取本地保存的用户信息等...
}

- (void)setupRootView {
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"iOSNativeDemo"
                                                 initialProperties:self.initialProperties
                                                     launchOptions:nil];
    self.view = rootView;
}

@end
