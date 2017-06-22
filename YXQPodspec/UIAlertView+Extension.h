//
//  UIAlertView+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/19.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedOtherButtonBlock)(void);

@interface UIAlertView (Extension)

+ (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
               Target:(id)sender
         CancelButton:(NSString *)cancelButtonTitle
          OtherButton:(NSString *)otherButtonTitle
       SelectedButton:(selectedOtherButtonBlock)selectedBlock;

+ (void)showWithMessage:(NSString *)message
                 Target:(id)sender
           CancelButton:(NSString *)cancelButtonTitle
            OtherButton:(NSString *)otherButtonTitle
         SelectedButton:(selectedOtherButtonBlock)selectedBlock;

+ (void)showWithMessage:(NSString *)message Target:(id)sender;

@end
