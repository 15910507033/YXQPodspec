//
//  RequestManager.h
//  YouGouApp
//
//  Created by iyan on 2017/6/16.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 全局的 key
#define KEY_SOURCEID      @"Sourceid"
#define KEY_UUID          @"uuid"
#define KEY_IDFA          @"idfa"
#define KEY_UNIQUEID      @"Unique"
#define KEY_USER_ID       @"UserId"
#define KEY_USER_SESSION  @"UserSession"

@interface RequestManager : NSObject

@property (nonatomic) NSInteger requestID;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableDictionary *param;

- (instancetype)initWithUrl:(NSString *)aUrl
                      param:(NSMutableDictionary *)aParam;

- (void)getRequest:(NSString *)flag
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

- (void)postRequest:(NSString *)flag
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

- (void)uploadRequest:(NSString *)flag
           imageDatas:(NSMutableArray *)imageDatas
           uploadName:(NSString *)imageName
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
       uploadProgress:(void (^)(NSProgress *uploadProgress))progress;

- (void)downloadRequest:(NSString *)flag
               savePath:(NSString *)destSavePath
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
            destination:(void (^)(NSURL *targetPath, NSURLResponse *response))destinationBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandlerBlock;

@end
