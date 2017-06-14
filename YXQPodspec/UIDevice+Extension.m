//
//  UIDevice+Extension.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "UIDevice+Extension.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/AdSupport.h>
#import <OpenUDID/OpenUDID.h>
#import "BXKeychain.h"

@implementation UIDevice (Extension)

+ (NSString *)KeychainUUID {
    NSString *uuid;
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    if ([[BXKeychain load:@"ios_uuid"] isEqualToString:@""] || [BXKeychain load:@"ios_uuid"] == nil) {
        [BXKeychain save:@"ios_uuid" data:uuid];
    }
    return [BXKeychain load:@"ios_uuid"];
}

+ (NSString *)MacAddress {
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for(NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifname);
        if(info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *ssid = [[dic objectForKey:@"SSID"] lowercaseString];
    NSString *bssid = [dic objectForKey:@"BSSID"];
    NSLog(@"ssid:%@ \n bssid:%@",ssid,bssid);
    return bssid;
}

+ (NSString *)OpenUDID {
    return [OpenUDID value];
}

+ (NSString *)IDFA {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

@end
