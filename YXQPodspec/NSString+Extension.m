//
//  NSString+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "NSString+Extension.h"
#import <RegexKitLite/RegexKitLite.h>
#import <CommonCrypto/CommonDigest.h>

NSString* const REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
NSString* const REG_MOBILE = @"^(14[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
NSString* const REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";

@implementation NSString (Extension)

- (BOOL)isEmptyString {
    if(self && self.length>0) {
        return NO;
    }
    return YES;
}

- (BOOL)isChineseValue {
    BOOL bChinese = YES;
    for(int i=0; i< [(NSString *)self length];i++) {
        int a = [(NSString *)self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa6) {
        } else {
            bChinese = NO;
            break;
        }
    }
    return bChinese;
}

- (BOOL)isEnglishValue {
    BOOL bEngilsh = YES;
    for(int i=0; i< [(NSString *)self length];i++) {
        int a = [(NSString *)self characterAtIndex:i];
        if((65 <= a  && a <= 90) ||
           (97 <= a  && a <= 122)) {
        } else {
            bEngilsh = NO;
        }
    }
    return bEngilsh;
}

- (BOOL)isEmail {
    return [self isMatchedByRegex:REG_EMAIL];
}

- (BOOL)isPhoneNum {
    return [self isMatchedByRegex:REG_PHONE];
}

- (BOOL)isMobileNum {
    return [self isMatchedByRegex:REG_MOBILE];
}

- (BOOL)isTextHaswhitespace {
    for(int i = 0; i < [(NSString *)self length]; ++i) {
        int a = [(NSString *)self characterAtIndex:i];
        if ([self isSpace:a] ||[self iswhitespace:a]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSpace:(NSInteger)characterAtIndex {
    if (32 == characterAtIndex) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)iswhitespace:(NSInteger)characterAtIndex {
    if (20 == characterAtIndex) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)deleteWhitespaceCharacters {
    NSCharacterSet *charset = [NSCharacterSet whitespaceCharacterSet];
    NSArray *charArr = [self componentsSeparatedByCharactersInSet:charset];
    NSMutableString *nString = [NSMutableString string];
    for (NSString *s in charArr) {
        [nString appendString:s];
    }
    return nString;
}

- (BOOL)isContainsEmoji {
    __block BOOL returnself = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs + 0xd800) * 0x400) + (ls + 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnself = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnself = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnself = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnself = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnself = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnself = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnself = YES;
             }
         }
     }];
    return returnself;
}

- (NSString *)cleanEmoji {
    NSString *regex = @"[^\\u0000-\\uFFFF]|[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]";
    //    NSString *regex = @"/\\uD83C[\\uDF00-\\uDFFF]|\\uD83D[\\uDC00-\\uDE4F]/g";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""]];
    return newStr;
}

- (NSString *)trimmedString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&#$%^&amp;*()_+'\""];
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:set];
    return trimmedString;
}

- (BOOL)isTrimmedString {
    if ([[self trimmedString] isEqualToString:@""] ||
        [self trimmedString].length == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isIDCard {
    NSString *value = [NSString stringWithString:self];
    if([[value substringWithRange:NSMakeRange(value.length-1,1)] isEqualToString:@"x"]){
        value = [[value stringByReplacingCharactersInRange:NSMakeRange(value.length-1,1) withString:@"X"] uppercaseString];
    }
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!value) {
        return NO;
    }else if (value.length != 15&&value.length != 18){
        //_cardIDErrorString = @"身份证号码格式不正确！";
        return NO;
    }
    // 省份代码 身份证前两位必须是这三十五种之一
    NSArray *provinceArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    BOOL isContain = false;
    for (NSString *province in provinceArray) {
        if ([province isEqualToString:[value substringToIndex:2]]){
            isContain = YES;
            break;
        }
    }
    if (isContain ==  NO) {
        return false;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year = 0;
    switch (value.length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year%4 == 0||(year%100 == 0&&year%4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                return YES;
            }else {
                //_cardIDErrorString = @"请输入正确的身份证号码！";
                return NO;
            }
        case 18:{
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year%4 == 0||(year%100 == 0&&year%4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *lastPlace =@"F";
                NSString *calibrate =@"10X98765432";
                lastPlace = [calibrate substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([lastPlace isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    //_cardIDErrorString = @"请输入正确的身份证号码！";
                    return NO;
                }
            }else {
                //_cardIDErrorString = @"请输入正确的身份证号码！";
                return NO;
            }
        }
        default:
            return false;
    }
}


- (NSString *)md5Hash {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], [data length], result);
    NSString *md5_result =
    [NSString stringWithFormat:
     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
     result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    return md5_result;
}


@end
