//
//  HeaderTabbar.h
//  YouGouApp
//
//  Created by iyan on 2017/6/27.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOPBAR_H    35

@interface HeaderTabbar : UIView

@property (nonatomic) CGFloat titleNormalFontSize;
@property (nonatomic) CGFloat titleSelectedFontSize;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 *  添加一个子控制器
 */
- (void)addSubItemWithViewController:(UIViewController *)viewController;

@end


@interface UIButton (HeaderTabbar)
- (void)addBottomLineWithFontSize:(CGFloat)fontSize Color:(UIColor *)lineColor;
- (void)hideBottomLine;
- (void)showBottomLine;
@end


