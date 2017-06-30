//
//  CountdownTimer.h
//  YouGouApp
//
//  Created by iyan on 2017/6/30.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COUNTDOWN_TIMER  [CountdownTimer shareInstance]

typedef void(^TimeIntervalBlock)(long timeInterval);

@interface CountdownTimer : NSObject

@property (nonatomic, strong) NSMutableDictionary *flagDict;

+ (CountdownTimer *)shareInstance;

- (void)cancelTimerWithFlag:(NSString *)flag;

- (void)timerWithInterval:(long)interval
                     Flag:(NSString *)flag
                Countdown:(TimeIntervalBlock)intervalBlock;

@end
