//
//  MHAliyunManager.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MHOOSImageModel;
typedef void(^progressBlock)(CGFloat progress);


@interface MHAliyunManager : NSObject
+ (id)sharedManager;

/** 获取OSS相关配置 */
- (void)getOssConfigWithCompleteBlock:(void(^)(BOOL success))compelete;

#pragma mark -
/**
 单张图片上传
 */
- (void)uploadImageToAliyunWithImage:(UIImage *)image
                             success:(void (^)(MHOOSImageModel *imageModel))successBlock
                              failed:(void (^)(NSString *errmsg))failedBlock;

/** 多张图片上传 */
- (void)uploadImageToAliyunWithArrayImage:(NSArray *)arrayImage
                                  success:(void (^)(NSArray<MHOOSImageModel *> *imageModels))successBlock
                                   failed:(void (^)(NSString *errmsg))failedBlock;
@end


@interface MHOOSImageModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic,copy) NSString *s_url;

@property (nonatomic,copy) NSString *file_id;
@property (nonatomic,copy) NSString *file_url;
@property (nonatomic,strong) NSNumber *img_width;
@property (nonatomic,strong) NSNumber *img_height;
@end
