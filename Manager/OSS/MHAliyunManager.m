//
//  MHAliyunManager.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAliyunManager.h"

#import "AliyunOSSiOS/OSSService.h"
#import <SDImageCache.h>

#import "MHWeakStrongDefine.h"
#import "MHUserInfoManager.h"

#import "MHNetworking.h"

static NSString * const kEndPoint = @"http://oss-cn-shenzhen.aliyuncs.com";
static NSString * const kBucketName = @"huijiale";

static NSString * const kErrmsg = @"图片上传失败";
//获取沙盒 Libaray目录的Cache
#define PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface MHAliyunManager ()
@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) NSMutableDictionary *putDict;
@end

@implementation MHAliyunManager
#pragma mark - Init
+ (id)sharedManager
{
    static MHAliyunManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MHAliyunManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setOSSConfig];
    }
    return self;
}

#pragma mark - OSS config
- (void)setOSSConfig {
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]
                                            initWithAccessKeyId: [MHUserInfoManager sharedManager].accessKeyId
                                            secretKeyId:[MHUserInfoManager sharedManager].accessKeySecret
                                            securityToken:[MHUserInfoManager sharedManager].securityToken];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    self.client = [[OSSClient alloc] initWithEndpoint:kEndPoint credentialProvider:credential clientConfiguration:conf];
   
    
}

/** 获取OSS相关配置 */
- (void)getOssConfigWithCompleteBlock:(void(^)(BOOL success))compelete{
    [[MHNetworking shareNetworking] post:@"osstoken/get" params:nil success:^(NSDictionary *data) {
            [MHUserInfoManager sharedManager].accessKeyId = data[@"AccessKeyId"] ? data[@"AccessKeyId"] : [NSNull null];
            [MHUserInfoManager sharedManager].accessKeySecret = data[@"AccessKeySecret"] ? data[@"AccessKeySecret"] : [NSNull null];
            [MHUserInfoManager sharedManager].securityToken = data[@"SecurityToken"] ? data[@"SecurityToken"] : [NSNull null];
        compelete(YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
         compelete(NO);
    }];
    
}

#pragma mark -
- (void)uploadImageToAliyunWithImage:(UIImage *)image success:(void (^)(MHOOSImageModel *model))successBlock failed:(void (^)(NSString *errmsg))failedBlock{
    NSAssert(image, @"image not be nil!");
    NSString *fileName = [NSString stringWithFormat:@"%@",[[NSUUID UUID].UUIDString stringByAppendingString:@".png"]];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = kBucketName;
    put.objectKey = fileName;
    
    NSString *urlStr = [self getDownloadURLStringWithObjectName:fileName];
    //add putDict
    [self.putDict setObject:put forKey:fileName];
    
    UIImage *newImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.6)];
    
    [[SDImageCache sharedImageCache] storeImage:newImage forKey:urlStr toDisk:YES];
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:urlStr completion:^(BOOL isInCache) {
        if (isInCache) {
            NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:urlStr];
            put.uploadingFileURL = [NSURL URLWithString:path];
            NSLog(@"Compressed File size is : %.2f KB",(float)UIImageJPEGRepresentation(image, 1).length/1024.0f);
            
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MHOOSImageModel *model = [[MHOOSImageModel alloc] init];
                        model.image = newImage;
                        model.name = fileName;
                        model.url = urlStr;
                        model.width = newImage.size.width;
                        model.height = newImage.size.height;
                        successBlock(model);
                    });
                } else {
                    if (task.error.code == -403|| task.error.code ==8) {
                        
                        [self getOssConfigWithCompleteBlock:^(BOOL success) {
                            if (success) {
                                [self setOSSConfig];
                                [self uploadImageToAliyunWithImage:image success:successBlock failed:failedBlock];
                            }else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    failedBlock(kErrmsg);
                                });
                            }
                        }];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failedBlock(kErrmsg);
                        });
                    }
                }
                [self.putDict removeObjectForKey:fileName];
                return nil;
            }];
        }
        
    }];
}

- (void)uploadImageToAliyunWithArrayImage:(NSArray *)arrayImage success:(void (^)(NSArray<MHOOSImageModel*> *))successBlock failed:(void (^)(NSString *errmsg))failedBlock{
    __block BOOL uploadSuccess = YES;
    __block NSMutableArray *imageModelArray = [NSMutableArray arrayWithCapacity:arrayImage.count];
    __block NSMutableDictionary *dict = @{}.mutableCopy;
    
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < arrayImage.count; i ++) {
        dispatch_group_enter(group);
        
        [self uploadImageToAliyunWithImage:arrayImage[i] success:^(MHOOSImageModel *model) {
            [dict setObject:model forKey:@(i)];
            dispatch_group_leave(group);
        } failed:^(NSString *errmsg){
            [self uploadImageToAliyunWithImage:arrayImage[i] success:^(MHOOSImageModel *model) {
                [dict setObject:model forKey:@(i)];
                dispatch_group_leave(group);
            } failed:^(NSString *errmsg){
                uploadSuccess = NO;
                dispatch_group_leave(group);
            }];
        }];
    }
    
    dispatch_group_notify(group,  dispatch_get_main_queue(), ^{
        if (uploadSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSInteger i = 0; i < dict.allKeys.count; i ++) {
                    MHOOSImageModel *model = dict[@(i)];
                    [imageModelArray addObject:model];
                }
                successBlock(imageModelArray.copy);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failedBlock(kErrmsg);
            });
        }
        
    });
}


#pragma mark - Get URL
- (NSString *)getDownloadURLStringWithObjectName:(NSString *)objectName{
    NSString * publicURL = nil;
    // sign public url
    OSSTask * task = [self.client presignPublicURLWithBucketName:kBucketName withObjectKey:objectName];
    if (!task.error) {
        publicURL = task.result;
        return publicURL;
    } else {
        return nil;
    }
}


#pragma mark - Getter
- (NSMutableDictionary *)putDict{
    if (!_putDict) {
        _putDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _putDict;
}

@end


@implementation MHOOSImageModel

- (void)setName:(NSString *)name{
    _name = name;
    self.file_id = name;
}

- (void)setUrl:(NSString *)url{
    _url = url;
    self.file_url = url;
}

- (void)setWidth:(CGFloat)width{
    _width = width;
    self.img_width = @(width);
}

- (void)setHeight:(CGFloat)height{
    self.img_height = @(height);
}

@end
