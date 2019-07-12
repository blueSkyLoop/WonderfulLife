//
//  JFAuthorizationStatusManager.h
//  JFCommunityCenter
//
//  Created by Beelin on 17/4/13.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JFAuthorizationType) {
    JFAuthorizationTypeAlbum, //相册类型
    JFAuthorizationTypeVideo, //视频、拍照类型
    JFAuthorizationTypeAudio,  //语音类型
    JFAuthorizationTypeMap  //地图类型
};
@interface JFAuthorizationStatusManager : NSObject

/**
 弹框
 @param type 类型
 @param target 弹框控制器
 */
+ (void)authorizationType:(JFAuthorizationType)type target:(UIViewController *)target;


/** 很单纯的检测权限 不弹框，可根据返回值自定义逻辑*/
+ (BOOL)authorizationStatusMediaTypeAlbumIsOpen;
+ (BOOL)authorizationStatusMediaTypeVideoIsOpen;
+ (BOOL)authorizationStatusMediaTypeAudioIsOpen;
+ (BOOL)authorizationStatusMediaTypeMapIsOpen;
@end
