//
//  RequestManager.m
//  YouGouApp
//
//  Created by iyan on 2017/6/16.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import <RSAEncryptor/RSAEncryptor.h>
#import <SBJson/SBJSON.h>

#import "UIDevice+Extension.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"

//请求时间
#define TIMEOUT_INTERVAL   30

//rsa加密
#define RSA_PULIC_KEY  \
@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7n4WxGOL+J94agHzcgelb4EhUM6jle1TxScN8l2yd6FIn5rM/iIb6n6iwJmjR0wVt9cY9g1Rdx8UeVaSQqXGcEZtmmhdhrjAkZPh/yNy0QWOalhVThr+reM1Ct1P+N5adbIf01e3biL7Fhy4O8w2JaX4jRAsjVmRyZLUMpXMhnQIDAQAB"

@interface RequestManager ()
@property (nonatomic, strong) NSMutableDictionary *requestDictionary;
@end

@implementation RequestManager

- (instancetype)initWithUrl:(NSString *)aUrl
                      param:(NSMutableDictionary *)aParam {
    if(self = [super init]) {
        self.url = aUrl;
        self.param = aParam;
    }
    return self;
}

- (NSMutableDictionary *)dictionary {
    return [RequestManager shareInstance].requestDictionary;
}

+ (RequestManager *)shareInstance {
    static RequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] init];
        instance.requestDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    });
    return instance;
}

//中断请求
- (void)stopRequestWithFlag:(NSString *)flag {
    if (flag) {
        NSURLSessionDataTask *task = self.dictionary[flag];
        if (task) {
            [self.dictionary removeObjectForKey:flag];
            [task cancel];
        }
    }
}

// 根据标记flag 获取请求task
- (NSURLSessionDataTask *)taskWithFlag:(NSString * _Nullable)flag {
    if (!flag)
        return nil;
    NSURLSessionDataTask *retTask = self.dictionary[flag];
    if (!retTask)
        return nil;
    return retTask;
}


- (void)getRequest:(NSString *)flag
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self currentManagerWithFlag:flag];
    __block NSString *blockFlag = nil;
    if (flag) {
        blockFlag = flag;
    }
    NSURLSessionDataTask *task =
    [manager GET:self.url parameters:self.param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (blockFlag)
            [self.dictionary removeObjectForKey:blockFlag];
        if ([responseObject bytes]) {
            success([self requestSuccessResponse:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (blockFlag)
            [self.dictionary removeObjectForKey:blockFlag];
        if (error.code == -999)
            return ;
        failure(error);
    }];
    if(flag) {
        self.dictionary[flag]= task;
    }
}

- (void)postRequest:(NSString *)flag
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self currentManagerWithFlag:flag];
    __block NSString *blockFlag = nil;
    if (flag) {
        blockFlag = flag;
    }
    NSURLSessionDataTask *task =
    [manager POST:self.url parameters:self.param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (blockFlag)
            [self.dictionary removeObjectForKey:blockFlag];
        if ([responseObject bytes]) {
            success([self requestSuccessResponse:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (blockFlag)
            [self.dictionary removeObjectForKey:blockFlag];
        if (error.code == -999)
            return ;
        failure(error);
    }];
    if(flag) {
        self.dictionary[flag]= task;
    }
}

- (void)uploadRequest:(NSString *)flag
           imageDatas:(NSMutableArray *)imageDatas
           uploadName:(NSString *)imageName
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
       uploadProgress:(void (^)(NSProgress *uploadProgress))progress
{
    AFHTTPSessionManager *manager = [self currentManagerWithFlag:flag];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",nil];
    [manager POST:self.url parameters:self.param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(int i=0; i<imageDatas.count; i++) {
            NSData *image = [imageDatas objectAtIndex:i];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[NSDate currentTimeStringByDateFormat:@"yyyyMMddHHmmss"], i];
            [formData appendPartWithFileData:image name:imageName fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject bytes]) {
            [self requestSuccessResponse:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -999)
            return ;
        failure(error);
    }];
}

- (void)downloadRequest:(NSString *)flag
               savePath:(NSString *)destSavePath
               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
            destination:(void (^)(NSURL *targetPath, NSURLResponse *response))destinationBlock
      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandlerBlock
{
    [self stopRequestWithFlag:flag];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __block NSString *blockFlag = nil;
    if (flag) {
        blockFlag = flag;
    }
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        downloadProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        destinationBlock(targetPath, response);
        return [NSURL fileURLWithPath:destSavePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (blockFlag) {
            [self.dictionary removeObjectForKey:blockFlag];
        }
        completionHandlerBlock(response, filePath, error);
    }];
    [task resume];
    if(flag) {
        self.dictionary[flag]= task;
    }
}



- (AFHTTPSessionManager *)currentManagerWithFlag:(NSString *)flag {
    [self stopRequestWithFlag:flag];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self setPublicRequestDatas:manager.requestSerializer];
    return manager;
}

- (id)requestSuccessResponse:(id  _Nullable)responseObject {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    //    NSString *jiashuju = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    if((responseObject != nil) && (dict == nil)) {
        NSData *responseData = (NSData *)responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        SBJsonParser *jsonParser = [SBJsonParser new];
        id repr = [jsonParser objectWithString:responseString];
        if (!repr)
            NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
        NSDictionary *jsonkitResponseObject = repr;
        //解析1：jsonkitResponseObject
        if(jsonkitResponseObject != nil) {
            return jsonkitResponseObject;
        }
        //解析2：responseData
        else if (responseData != nil) {
            return responseData;
        }else {
            return nil;
        }
    }
    //解析3：dict
    return dict;
}

// 请求时通用的基本数据
- (void)setPublicRequestDatas:(id)requestSerializer {
    [requestSerializer setValue:@"9980998" forHTTPHeaderField:@"Appkey"];
    [requestSerializer setValue:@"ios" forHTTPHeaderField:@"Os"];
    [requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"Osversion"];
    NSString *app_version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [requestSerializer setValue:app_version forHTTPHeaderField:@"Appversion"];
    [requestSerializer setValue:@"1.0" forHTTPHeaderField:@"Ver"];
    [requestSerializer setValue:@"vm8" forHTTPHeaderField:@"productLine"];
    
    NSString *saved_uuid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UUID];
    NSString *saved_idfa = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IDFA];
    NSString *saved_sourceid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SOURCEID];
    [requestSerializer setValue:saved_uuid forHTTPHeaderField:@"uuid"];
    [requestSerializer setValue:saved_idfa forHTTPHeaderField:@"idfa"];
    [requestSerializer setValue:saved_sourceid forHTTPHeaderField:@"Sourceid"];
    
    NSString *time = [NSDate currentTimeStringByDateFormat:@"yyyyMMddHHMMssSSS"];
    NSString *token = [NSString stringWithFormat:@"%@_%@",saved_uuid,time];
    NSString *rsa   = [RSAEncryptor encryptString:token publicKey:RSA_PULIC_KEY];
    [requestSerializer setValue:rsa forHTTPHeaderField:@"token"];
    [requestSerializer setValue:time forHTTPHeaderField:@"random"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Userid"]) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Userid"];
        if(![userid isEmptyString]) {
            [requestSerializer setValue:userid forHTTPHeaderField:@"Userid"];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Usersession"]) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Usersession"];
        if(![userid isEmptyString]) {
            [requestSerializer setValue:userid forHTTPHeaderField:@"Usersession"];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:KEY_UNIQUEID]) {
        NSString *uniqueid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UNIQUEID];
        if(![uniqueid isEmptyString]) {
            [requestSerializer setValue:uniqueid forHTTPHeaderField:@"Unique"];
        }
    }
}


@end
