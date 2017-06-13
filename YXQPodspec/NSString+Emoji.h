//
//  NSString+Emoji.h
//  YouGou
//
//  Created by Brian on 16/7/12.
//  Copyright (c) 2013 Valerio Mazzeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/**
 *  过滤Emoji表情（去除）
 *  iOS9的emoji编码范围还未确定导致部分（新增）表情无法过滤
 *  @return 去掉Emoji表情后的String
 */
- (NSString *)stringByCleanEmoji;


@end
