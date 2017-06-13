//
//  XQNavigationController.m
//  mall
//
//  Created by iyan on 2017/4/27.
//  Copyright © 2017年 jingyuhuatong. All rights reserved.
//

#import "XQNavigationController.h"

@interface XQNavigationController ()

@end

@implementation XQNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
