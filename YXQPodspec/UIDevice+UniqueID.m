//
//  UIDevice+UniqueID.m
//  YouGouApp
//
//  Created by iyan on 2017/6/14.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "UIDevice+UniqueID.h"
#import "BXKeychain.h"

@implementation UIDevice (UniqueID)

- (NSString *) uniqueGlobalDeviceIdentifierUUID{
    NSString * uuid;
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    if ([[BXKeychain load:@"ios_uuid"] isEqualToString:@""] || [BXKeychain load:@"ios_uuid"] == nil) {
        [BXKeychain save:@"ios_uuid" data:uuid];
    }
    return [BXKeychain load:@"ios_uuid"];
}

@end
