//
//  MHHUDManager.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHUDManager.h"
#import "SVProgressHUD.h"

#import "MHMacros.h"
#import "MHConst.h"

#import "NSObject+isNull.h"

@implementation MHHUDManager

+ (void)showText:(NSString *)text {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setBackgroundColor:MColorToRGB(0X475669)];
    [SVProgressHUD showImage:nil status:text];
    [SVProgressHUD dismissWithDelay:2];
    [SVProgressHUD resetOffsetFromCenter];
}

+ (void)showText:(NSString *)text Complete:(void (^)())completeBlock{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setBackgroundColor:MColorToRGB(0X475669)];
    [SVProgressHUD showImage:nil status:text];
    [SVProgressHUD dismissWithDelay:2 completion:completeBlock];
    [SVProgressHUD resetOffsetFromCenter];
}

+ (void)showErrorText:(NSString *)text {
    if ([NSObject isNull:text]) {
        [self showText:kErrorMsg];
    } else {
        [self showText:text];
    }
}

+ (void)show {
    [SVProgressHUD setForegroundColor:[UIColor redColor]];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack]; //don't allow user interactions
    [SVProgressHUD setRingThickness:5];
    [SVProgressHUD show];
}



+ (void)dismiss {
    [SVProgressHUD dismiss];
}

/*************************add by Lance 2017.10.27*************************/

/** 启动无限旋转装逼模式 导航栏返回键不可以交互，携带文字*/
+ (void)showWithInfor:(NSString *)inforStr{
    [SVProgressHUD setForegroundColor:[UIColor redColor]];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack]; //don't allow user interactions
    [SVProgressHUD setRingThickness:5];
    if(inforStr && inforStr.length){
        [SVProgressHUD showWithStatus:inforStr];
    }else{
        [SVProgressHUD show];
    }
}

/*
 显示错误信息，内置判空操作，并自动显示默认错误文本 ,错误文本为error.userInfo[@"errmsg"] ,
 通过传入aview，判断当前这个aview是不是显示，不显示则不弹出错误信息，避免错误信息在别的界面弹出
 */
+ (void)showWithError:(NSError *)error withView:(UIView *)aview{
    if(!aview.window) return;
    NSString *message = error.userInfo[@"errmsg"];
    if(!message || message.length == 0) return;
    [self showErrorText:message];
}


@end
