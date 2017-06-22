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
               Target:(id)sender
         CancelButton:(NSString *)cancelButtonTitle
          OtherButton:(NSString *)otherButtonTitle
       SelectedButton:(selectedOtherButtonBlock)selectedBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(cancelButtonTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
    }
    if(otherButtonTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            selectedBlock();
        }]];
    }
    [sender presentViewController:alertController animated:YES completion:nil];
}

+ (void)showWithMessage:(NSString *)message
                 Target:(id)sender
           CancelButton:(NSString *)cancelButtonTitle
            OtherButton:(NSString *)otherButtonTitle
         SelectedButton:(selectedOtherButtonBlock)selectedBlock {
    
    [self showWithTitle:@"温馨提示" Message:message Target:sender CancelButton:cancelButtonTitle OtherButton:otherButtonTitle SelectedButton:selectedBlock];
}

+ (void)showWithMessage:(NSString *)message Target:(id)sender {
    [self showWithTitle:@"温馨提示" Message:message Target:sender CancelButton:@"知道了" OtherButton:nil SelectedButton:nil];
}

@end
