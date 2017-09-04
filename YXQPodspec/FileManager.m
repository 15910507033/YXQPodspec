//
//  FileManager.m
//  YouGou
//
//  Created by iyan on 17/1/9.
//
//

#import "FileManager.h"
#import <SDWebImage/SDImageCache.h>

static FileManager *sharedInstance = nil;

@interface FileManager ()
@property (nonatomic, strong) NSFileManager *manager;
@end

@implementation FileManager

#pragma mark - 单例构造
+ (FileManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (NSFileManager *)manager {
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    return _manager;
}

#pragma mark - 路径

#pragma mark Document (一般需要持久的数据都放在此目录中，可以在当中添加子文件夹，iTunes备份和恢复的时候，会包括此目录。)
+ (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

#pragma mark Library (设置程序的默认设置和其他状态信息)
+ (NSString *)libraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

#pragma mark Cache (Library中的Cache,缓存文件存放路径，每次退出App后清空)
+ (NSString *)cachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

#pragma mark temp (创建临时文件的目录，当iOS设备重启时，文件会被自动清除)
+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

#pragma mark Home (根目录)

+ (NSString *)homePath {
    return  NSHomeDirectory();
}

#pragma mark - data -> image

+ (UIImage *)imageWithData:(NSData *)imageData {
    return [UIImage imageWithData: imageData];
}

#pragma mark - name -> image

+ (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:name];
    NSData *imageData = [NSData dataWithContentsOfFile: finalPath];
    return [UIImage imageWithData: imageData];
}

#pragma mark path -> data
+ (NSData *)dataFromPath:(NSString *)path {
    return [[self defaultManager].manager contentsAtPath:path];
}

#pragma mark path -> image
+ (UIImage *)imageFromPath:(NSString *)path {
    return [self imageWithData:[self dataFromPath:path]];
}


#pragma mark - document文件定位 （获取文件路径）
+ (NSString *)getLocalFilePath:(NSString *) fileName
{
    return [NSString stringWithFormat:@"%@/%@%@", NSHomeDirectory(),@"Documents",fileName];
}

#pragma mark - 校验文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[self defaultManager].manager fileExistsAtPath:path];
}

#pragma mark - 移除文件
+ (BOOL)removeItemAtPath:(NSString *)path {
    NSError *error;
    return [[self defaultManager].manager removeItemAtPath:path error:&error];
}

#pragma mark - 文件大小
+ (NSInteger)fileSizeFromPath:(NSString *)path {
    // 先判断文件是否存在
    
    BOOL isDirectory = NO;
    BOOL exist = [[self defaultManager].manager fileExistsAtPath:path isDirectory:&isDirectory];
    // 如果文件不存在
    if (exist==NO) return 0;
    
    // 如果文件存在  判断为文件夹还是文件
    if (isDirectory) {
        // 计算文件大小。拿到了完整路径
        NSInteger fileSize = 0;
        // 用完整路径查询所有的文件的大小,返回为数组
        NSArray *pathArray = [[self defaultManager].manager subpathsAtPath:path];
        
        // 遍历数组,将获得的数组字符串拼接到file上
        for (NSString *path in pathArray) {
            // 获得完整地址
            NSString *fulSubPath = [path stringByAppendingPathComponent:path];
            // 获得属性
            NSDictionary *attrs = [[self defaultManager].manager attributesOfItemAtPath:fulSubPath error:nil];
            // 过滤掉文件夹
            if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
            // 将属性中的fileSize相加。
            fileSize += [attrs[NSFileSize] integerValue];
        }
        return fileSize;
        
    }
    return [[[self defaultManager].manager attributesOfItemAtPath:path error:nil][NSFileSize] integerValue];
}

+ (void)clearCache {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *cachPath = [self cachePath];
        NSArray *files = [[self defaultManager].manager subpathsAtPath :cachPath];
        
        for ( NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent :p];
            if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
                [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            }
        }
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{}];
    });
}

+ (CGFloat)sizeOfCachePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if([file_manager fileExistsAtPath:path]) {
        NSEnumerator *childFilesEnumerator = [[file_manager subpathsAtPath:path] objectEnumerator];
        long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([file_manager fileExistsAtPath:fileAbsolutePath]){
                folderSize += [[file_manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
            }else {
                folderSize += 0;
            }
        }
        return folderSize/(1024.0*1024.0);
    }
    return 0;
}

@end
