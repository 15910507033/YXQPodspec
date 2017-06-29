//
//  UILabel+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 * 创建label
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                       Text:(NSString *)text
                  TextColor:(NSString *)colorString
                       Font:(CGFloat)fontSize;

/**
 * 获取label的宽度
 */
+ (CGFloat)getLableWidthByStirng:(NSString *)string FontSize:(CGFloat)fontsize;


/**
 * 获取label的高度
 */
+ (CGFloat)getLableHeightByStirng:(NSString *)string FontSize:(CGFloat)fontsize
                            Width:(CGFloat)width Lines:(NSInteger)lines;

/**
 * 添加中间横线
 */
- (void)addStricklineWithColor:(NSString *)color Heigh:(CGFloat)height;

@end
