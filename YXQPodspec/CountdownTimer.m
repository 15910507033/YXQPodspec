//
//  CountdownTimer.m
//  YouGouApp
//
//  Created by iyan on 2017/6/30.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "CountdownTimer.h"

#define INTERVAL @"interval"
#define BLOCK    @"block"

static CountdownTimer *shareInstance = nil;

@interface CountdownTimer ()
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation CountdownTimer

+ (CountdownTimer *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:zone];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.flagDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)cancelTimerWithFlag:(NSString *)flag {
    [self.flagDict removeObjectForKey:flag];
    NSArray *allkeys = [self.flagDict allKeys];
    if (!allkeys || allkeys.count == 0) {
        if (self.timer) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
        }
    }
}

- (void)timerWithInterval:(long)interval
                     Flag:(NSString *)flag
                Countdown:(TimeIntervalBlock)intervalBlock {
    if (interval == 0) {
        return;
    }
    //添加定时器
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:self.flagDict[flag]];
    if (!userInfo || [userInfo allKeys].count == 0) {
        userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [userInfo setObject:[NSNumber numberWithLong:0] forKey:INTERVAL];
    }
    //添加时间参数
    long timeInterval = [(NSNumber *)userInfo[INTERVAL] longValue];
    if(timeInterval==0) {
        [userInfo setObject:[NSNumber numberWithLong:interval] forKey:INTERVAL];
    }
    //添加block参数
    [userInfo setObject:intervalBlock forKey:BLOCK];
    [self.flagDict setObject:userInfo forKey:flag];
    
    //设置所有倒计时
    [self resumeTimer];
}


//所有倒计时运行
- (void)resumeTimer {
    if(self.timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        
        WEAK_SELF
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                STRONG_INBLOCK_SELF
                for(NSString *flag in self.flagDict.allKeys) {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:self.flagDict[flag]];
                    long timeInterval = [(NSNumber *)userInfo[INTERVAL] longValue];
                    TimeIntervalBlock block = [userInfo objectForKey:BLOCK];
                    block(timeInterval);
                    //时间到
                    if(timeInterval == 0) {
                        [strongSelf cancelTimerWithFlag:flag];
                    }
                    //继续倒计时
                    else {
                        timeInterval-=1;
                        [userInfo setObject:[NSNumber numberWithLong:timeInterval] forKey:INTERVAL];
                        [self.flagDict setObject:userInfo forKey:flag];
                    }
                }
            });
        });
        dispatch_resume(self.timer);
    }
}

@end
