//
//  NSString+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)stringIsEmpty:(NSString *)string {
    BOOL ret = NO;
    if(string == nil){
        ret = YES;
    } else {
        NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([temp length] < 1) {
            ret=YES;
        }
    }
    return ret;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs + 0xd800) * 0x400) + (ls + 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}

- (NSString *)stringByCleanEmoji {
    NSString *regex = @"[^\\u0000-\\uFFFF]|[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]";
    //    NSString *regex = @"/\\uD83C[\\uDF00-\\uDFFF]|\\uD83D[\\uDC00-\\uDE4F]/g";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""]];
    return newStr;
}

@end
