//
//  AppCommonMacro.h
//  YouGouApp
//
//  Created by iyan on 2017/6/22.
//  Copyright © 2017年 iyan. All rights reserved.
//

#ifndef AppCommonMacro_h
#define AppCommonMacro_h

#define NAV_H     64
#define TAB_H     56
#define TOP       20

#pragma mark 通用的简写
#define MAIN_BUNDLE    [NSBundle mainBundle]
#define CURR_DEVICE    [UIDevice currentDevice]
#define USER_DEFAULTS  [NSUserDefaults standardUserDefaults]
#define NOTIFY_CENTER  [NSNotificationCenter defaultCenter]
#define FILE_MANAGER   [NSFileManager defaultManager]
#define APP_DELEGATE   ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APP_VERSION    (MAIN_BUNDLE.infoDictionary[@"CFBundleShortVersionString"])

#define SCREEN_W             [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H             [[UIScreen mainScreen] bounds].size.height
#define SCREEN_FRAME         CGRectMake(0, 0, SCREEN_W, SCREEN_H)
#define SCALE_750            (SCREEN_W/375.0)
#define SCALE_640            (SCREEN_W/320.0)
#define WEAK_SELF            __weak __typeof(self) weakSelf= self;
#define STRONG_INBLOCK_SELF  __strong typeof (weakSelf) strongSelf = weakSelf;
#define PX(P)                (1.0 / [UIScreen mainScreen].scale) * (CGFloat)P

#endif /* AppCommonMacro_h */
