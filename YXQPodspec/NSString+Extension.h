//
//  NSString+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 * 字符串是否为空
 */
- (BOOL)stringIsEmpty:(NSString *)string;

/**
 * 判断是否含有emoji表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  过滤Emoji表情（去除）
 *  iOS9的emoji编码范围还未确定导致部分（新增）表情无法过滤
 *  @return 去掉Emoji表情后的String
 */
- (NSString *)stringByCleanEmoji;

@end
