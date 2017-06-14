//
//  NSDate+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 * 当前时间字符串
 */
- (NSString *)currentTimeStringByDateFormat:(NSString *)format;

/**
 * 根据时间字符串，转化为时间
 */
- (NSDate *)dateByTimeString:(NSString *)time DateFormat:(NSString *)format;

/**
 * 根据时间，转化为时间字符串
 */
- (NSString *)timeStringByDate:(NSDate *)date DateFormat:(NSString *)format;

/**
 * 根据时间字符串，得到几月几日
 */
- (NSString *)getJiYueJiRiByTimeString:(NSString *)time DateFormat:(NSString *)format;

/**
 * 是否已保存的日期已经过去
 */
- (BOOL)isAnotherDay;

@end
