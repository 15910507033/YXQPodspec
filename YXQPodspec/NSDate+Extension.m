//
//  NSDate+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)currentTimeStringByDateFormat:(NSString *)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:format];
    NSTimeZone *currentZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:currentZone];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSDate *)dateByTimeString:(NSString *)time DateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:time];
    return date;
}

- (NSString *)timeStringByDate:(NSDate *)date DateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:format];
    NSString *destDateString = [formatter stringFromDate:date];
    return destDateString;
}

- (NSString *)getJiYueJiRiByTimeString:(NSString *)time DateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp = [cal components:unitFlags fromDate:date];
    NSString *result = [NSString stringWithFormat:@"%ld月%ld日", [comp month], [comp day]];
    return result;
}

- (BOOL)isAnotherDay {
    BOOL isAnotherDay = YES;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *currentTime = [dateFormat stringFromDate:[NSDate date]];
    NSString *savedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"saved_time"];
    if(savedTime.length > 0) {
        NSDate *dateNow  = [dateFormat dateFromString:currentTime];
        NSDate *date = [dateFormat dateFromString:savedTime];
        NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
        NSDate *dateSave = [date dateByAddingTimeInterval:-interval];
        if (!([dateNow compare:dateSave] == NSOrderedDescending)) {
            isAnotherDay = NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"saved_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return isAnotherDay;
}

@end
