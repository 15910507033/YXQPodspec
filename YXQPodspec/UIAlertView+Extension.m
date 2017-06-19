//
//  UIAlertView+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/19.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "UIAlertView+Extension.h"

@implementation UIAlertView (Extension)

+ (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
                  Tag:(NSInteger)tag
               Target:(id)sender
         CancelButton:(NSString *)cancelButtonTitle
          OtherButton:(NSString *)otherButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:sender cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    alert.tag = tag;
    [alert show];
}

+ (void)showWithMessage:(NSString *)message {
    [self showWithTitle:@"温馨提示" Message:message Tag:0 Target:nil
           CancelButton:@"知道了" OtherButton:nil];
}

+ (void)showWithMessage:(NSString *)message
                    Tag:(NSInteger)tag
                 Target:(id)sender {
    [self showWithTitle:@"温馨提示" Message:message Tag:tag Target:sender
           CancelButton:@"知道了" OtherButton:nil];
}

+ (void)showWithMessage:(NSString *)message
                    Tag:(NSInteger)tag
                 Target:(id)sender
           CancelButton:(NSString *)cancelButtonTitle
            OtherButton:(NSString *)otherButtonTitle {
    [self showWithTitle:@"温馨提示" Message:message Tag:tag Target:sender
           CancelButton:cancelButtonTitle OtherButton:otherButtonTitle];
}

@end
