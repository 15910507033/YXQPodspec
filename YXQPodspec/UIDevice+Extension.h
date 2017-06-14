//
//  UIDevice+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)

- (NSString *)KeychainUUID;
- (NSString *)MacAddress;
- (NSString *)OpenUDID;
- (NSString *)IDFA;

@end
