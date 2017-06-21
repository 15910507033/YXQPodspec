//
//  UIDevice+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PHONE_4W  320.0
#define PHONE_4H  480.0
#define PHONE_5W  320.0
#define PHONE_5H  568.0
#define PHONE_6W  375.0
#define PHONE_6H  667.0
#define PHONE_PW  414.0
#define PHONE_PH  736.0

@interface UIDevice (Extension)

+ (NSString *)KeychainUUID;
+ (NSString *)MacAddress;
+ (NSString *)OpenUDID;
+ (NSString *)IDFA;

@end
