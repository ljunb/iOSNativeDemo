//
//  RNViewController.h
//  iOSNativeDemo
//
//  Created by CookieJ on 2017/12/3.
//  Copyright © 2017年 ljunb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNViewController : UIViewController

/**
 通过pageName的方式初始化

 @param pageName 不同RN的界面名称
 @return RNViewController实例
 */
- (instancetype)initWithPageName:(NSString *)pageName;

@end
