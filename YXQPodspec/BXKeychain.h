//
//  BXKeychain.h
//  IBoXiao_ios
//
//  Created by chenrui on 14-5-29.
//  Copyright (c) 2014年 ___boxiao___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
