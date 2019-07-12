//
//  JFCacheManager.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/11/14.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "JFCacheManager.h"
#import <UIImageView+WebCache.h>

@implementation JFCacheManager {
    float cache;
}

- (void)showCachesWithComplete:(void(^)(BOOL success,CGFloat cache))complete {
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self asyncShowCacheWithComplete:complete];
    });
}

- (void)clearCachesWithComplete:(void(^)(BOOL success,CGFloat cache))complete {
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self asyncClearCacheWithComplete:complete];
    });
}

#pragma mark  --异步执行的方法

- (void)asyncShowCacheWithComplete:(void(^)(BOOL success,CGFloat cache))complete {
    
    NSArray *pathArray = [self getpathArray];
    cache = 0;
    for (NSString *path in pathArray) {
        [self addCacheSizeWithPath:path];
    }
    //    long long sdWeb = [[SDImageCache sharedImageCache] getSize];
    //    cache+=sdWeb/(1024.0 * 1024.0);//sdWeb图片缓存
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
#pragma mark   ---更新UI
        if (complete) {
            complete(YES,cache);
        }
    }];
}

- (void)asyncClearCacheWithComplete:(void(^)(BOOL success,CGFloat cache))complete {
    
    NSArray *pathArray = [self getpathArray];
    
    for (NSString *path in pathArray) {
        NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :path];
        for ( NSString * p in files) {
            NSError * error = nil ;
            NSString * subPath = [path stringByAppendingPathComponent :p];
            if ([[ NSFileManager defaultManager ] fileExistsAtPath :subPath]) {
                [[ NSFileManager defaultManager ] removeItemAtPath :subPath error :&error];
            }
        }
    }
    
    [[SDImageCache sharedImageCache] clearMemory];
    //    [self clearSdWebPics];
    
    [self asyncShowCacheWithComplete:complete];
    
}




/**
 *  计算path路径下文件大小，并叠加到cache变量
 */

- (void)addCacheSizeWithPath:(NSString*)cachPath {
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :cachPath]) {
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :cachPath] objectEnumerator ];
        NSString * fileName;
        long long folderSize = 0 ;
        while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
            NSString * fileAbsolutePath = [cachPath stringByAppendingPathComponent :fileName];
            folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        }
        cache+=folderSize/(1024.0 * 1024.0);
    }
}
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath])
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    return 0 ;
}



/**
 *   返回:需要清理的沙盒路径
 */

- (NSArray *)getpathArray {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSString * libraryPath = [ NSSearchPathForDirectoriesInDomains ( NSLibraryDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * libraryFiles = [[ NSFileManager defaultManager ] subpathsAtPath :libraryPath];
    for ( NSString * p in libraryFiles) {
        /*  Library/Cookies */
        if ([p isEqualToString:@"Cookies"]) {
            NSString * path = [libraryPath stringByAppendingPathComponent :p];
            [array addObject:path];
        }
        /*  Library/Caches */
        if ([p isEqualToString:@"Caches"]) {
            NSString * path = [libraryPath stringByAppendingPathComponent :p];
            [array addObject:path];
        }
    }
    
    return [array copy];
}




#pragma mark  -- 废弃

- (void)clearSdWebPics{
    //清理磁盘
    [[SDImageCache sharedImageCache] clearDisk];
    //清理内存
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
