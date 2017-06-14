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
 * 获取label的宽度
 */
+ (CGFloat)getLableWidthByStirng:(NSString *)string FontSize:(CGFloat)fontsize;


/**
 * 获取label的高度
 */
+ (CGFloat)getLableHeightByStirng:(NSString *)string FontSize:(CGFloat)fontsize
                            Width:(CGFloat)width Lines:(NSInteger)lines;

@end
