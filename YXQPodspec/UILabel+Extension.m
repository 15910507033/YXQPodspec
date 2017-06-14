//
//  UILabel+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (CGFloat)getLableWidthByStirng:(NSString *)string FontSize:(CGFloat)fontsize {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:fontsize];
    label.text = string;
    [label sizeToFit];
    return label.frame.size.width;
}


- (CGFloat)getLableHeightByStirng:(NSString *)string FontSize:(CGFloat)fontsize
                            Width:(CGFloat)width Lines:(NSInteger)lines {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.font = [UIFont systemFontOfSize:fontsize];
    label.text = string;
    label.numberOfLines = lines;
    [label sizeToFit];
    return label.frame.size.height;
}

@end
