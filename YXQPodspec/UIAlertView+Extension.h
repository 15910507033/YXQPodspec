//
//  UIAlertView+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/19.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Extension)

+ (void)showWithTitle:(NSString *)title
              Message:(NSString *)message
                  Tag:(NSInteger)tag
               Target:(id)sender
         CancelButton:(NSString *)cancelButtonTitle
          OtherButton:(NSString *)otherButtonTitle;

+ (void)showWithMessage:(NSString *)message;

+ (void)showWithMessage:(NSString *)message
                    Tag:(NSInteger)tag
                 Target:(id)sender;

+ (void)showWithMessage:(NSString *)message
                    Tag:(NSInteger)tag
                 Target:(id)sender
           CancelButton:(NSString *)cancelButtonTitle
            OtherButton:(NSString *)otherButtonTitle;

@end
