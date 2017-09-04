//
//  FileManager.h
//  YouGou
//
//  Created by iyan on 17/1/9.
//
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (FileManager *)defaultManager;

#pragma mark Document (一般需要持久的数据都放在此目录中，可以在当中添加子文件夹，iTunes备份和恢复的时候，会包括此目录。)
+ (NSString *)documentPath;

#pragma mark Library (设置程序的默认设置和其他状态信息)
+ (NSString *)libraryPath;

#pragma mark Cache (Library中的Cache,缓存文件存放路径，每次退出App后清空)
+ (NSString *)cachePath;

#pragma mark temp (创建临时文件的目录，当iOS设备重启时，文件会被自动清除)
+ (NSString *)tempPath;

#pragma mark Home (根目录)

+ (NSString *)homePath;

#pragma mark - data -> image

+ (UIImage *)imageWithData:(NSData *)imageData;

#pragma mark - name -> image

+ (UIImage *)imageWithName:(NSString *)name;

#pragma mark path -> data
+ (NSData *)dataFromPath:(NSString *)path;

#pragma mark path -> image
+ (UIImage *)imageFromPath:(NSString *)path;

#pragma mark - document文件定位 （获取文件路径）
+ (NSString *)getLocalFilePath:(NSString *) fileName;

#pragma mark - 校验文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

#pragma mark - 移除文件
+ (BOOL)removeItemAtPath:(NSString *)path;

#pragma mark - 文件大小
+ (NSInteger)fileSizeFromPath:(NSString *)path;

#pragma mark - 清理缓存
+ (void)clearCache;

#pragma mark - 缓存的大小
+ (CGFloat)sizeOfCachePath;

@end
