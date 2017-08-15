//
//  UIImage+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 * 根据url生成图片
 */
+ (UIImage *)imageWithUrl:(NSString *)imageUrl;

/**
 * 获取等比缩放的高度
 */
+ (CGFloat)heightWithScaleWidth:(CGFloat)scaleWidth OriginSize:(CGSize)originSize;

/**
 * 自动计算网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)imageURL;

/**
 * 根据视图生成图片
 */
+ (UIImage *)makeImageWithView:(UIView *)view;

@end
