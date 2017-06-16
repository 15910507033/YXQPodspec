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
- (BOOL)isEmpty;

/**
 * 是否为中文
 */
- (BOOL)isChineseValue;

/**
 * 是否为英文
 */
- (BOOL)isEnglishValue;

/**
 * 是否为邮箱
 */
- (BOOL)isEmail;

/**
 * 是否为座机
 */
- (BOOL)isPhoneNum;

/**
 * 是否为手机
 */
- (BOOL)isMobileNum;

/**
 * 是否包含空格
 */
- (BOOL)isTextHaswhitespace;

/**
 * 判断是否含有emoji表情
 */
- (BOOL)isContainsEmoji;

/**
 *  过滤Emoji表情（去除）
 *  iOS9的emoji编码范围还未确定导致部分（新增）表情无法过滤
 *  @return 去掉Emoji表情后的String
 */
- (NSString *)cleanEmoji;

/**
 * 是否为身份证
 */
- (BOOL)isIDCard;

@end
