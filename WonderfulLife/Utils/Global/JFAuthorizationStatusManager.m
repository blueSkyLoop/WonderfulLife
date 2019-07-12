//
//  JFAuthorizationStatusManager.m
//  JFCommunityCenter
//
//  Created by Beelin on 17/4/13.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "JFAuthorizationStatusManager.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

#import "UIAlertController+JFAlertStyle.h"

@implementation JFAuthorizationStatusManager

#pragma mark - Public Method
+ (void)authorizationType:(JFAuthorizationType)type target:(UIViewController *)target {
    switch (type) {
        case JFAuthorizationTypeAlbum:
            [self authorizationStatusMediaTypeAlbumWithTarget:target];
            break;
        case JFAuthorizationTypeVideo:
            [self authorizationStatusMediaTypeVideoWithTarget:target];
            break;
        case JFAuthorizationTypeAudio:
            [self authorizationStatusMediaTypeAudioWithTarget:target];
            break;
         case JFAuthorizationTypeMap:
            [self authorizationStatusMediaTypeMapWithTarget:target];
            break;
        default:
            break;
    }
}

+ (BOOL)authorizationStatusMediaTypeAlbumIsOpen {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted ||
        authStatus == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)authorizationStatusMediaTypeAudioIsOpen {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

+ (BOOL)authorizationStatusMediaTypeVideoIsOpen {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)authorizationStatusMediaTypeMapIsOpen {
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusRestricted || authStatus ==kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

#pragma mark - Private Method
+ (void)authorizationStatusMediaTypeAlbumWithTarget:(UIViewController *)target{
    if (![self authorizationStatusMediaTypeAlbumIsOpen]) {
        [self alertTitle:@"请在iPhone的【设置】-【隐私】-【照片】中，允许美好志愿访问你的手机相册。" Target:target];
    }
}

+ (void)authorizationStatusMediaTypeVideoWithTarget:(UIViewController *)target{
    if (![self authorizationStatusMediaTypeVideoIsOpen]) {
        [self alertTitle:@"请在iPhone的【设置】-【隐私】-【相机】中，允许美好志愿访问你的摄像头。" Target:target];
    }
}


+ (void)authorizationStatusMediaTypeAudioWithTarget:(UIViewController *)target{
    if (![self authorizationStatusMediaTypeAudioIsOpen]) {
        [self alertTitle:@"请在iPhone的【设置】-【隐私】-【麦克风】中允许访问语音。" Target:target];
    }
}

+ (void)authorizationStatusMediaTypeMapWithTarget:(UIViewController *)target{
    if (![self authorizationStatusMediaTypeMapIsOpen]) {
        [UIAlertController jf_alertWithTitle:@"定位服务已关闭" message:@"无法获取你的位置信息，请到手机系统的【设置】-【隐私】-【定位服务】中打开定位服务，并允许美好志愿使用定位服务。"];
//        [self alertTitle:@"请在手机的[设置]->[隐私]->[相机]中允许访问地图" Target:target];
    }
}

+ (void)alertTitle:(NSString *)title Target:(UIViewController *)target{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }];
//    [alert addAction:cancle];
//    [alert addAction:setting];
    
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
   [alert addAction:determine];
    
    [target presentViewController:alert animated:YES completion:nil];
    return;
}


@end
