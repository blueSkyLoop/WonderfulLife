//
//  UIViewController+CameraSheet.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import <objc/runtime.h>

@interface UIViewController (CameraSheet) <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *mhImagePickerVc;
@property (strong, nonatomic) CLLocation *mhLocation;
@property (weak, nonatomic) UIImageView *mhIconView;
- (UIAlertController *)mh_showCameraSheet;
- (void)dosomethingWithImage:(UIImage *)image;
@end
