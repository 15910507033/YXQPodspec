//
//  NSString+Emoji.m
//  YouGou
//
//  Created by Brian on 16/7/12.
//
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)


- (NSString *)stringByCleanEmoji {
    NSString *regex = @"[^\\u0000-\\uFFFF]|[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]";
//    NSString *regex = @"/\\uD83C[\\uDF00-\\uDFFF]|\\uD83D[\\uDC00-\\uDE4F]/g";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:[regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""]];

        return newStr;
}
@end
