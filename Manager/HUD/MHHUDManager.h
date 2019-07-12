//
//  MHHUDManager.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHHUDManager : NSObject

/** 显示文本 */
+ (void)showText:(NSString *)text;
/** 显示错误信息，内置判空操作，并自显示默认错误文本 */
+ (void)showErrorText:(NSString *)text;

+ (void)showText:(NSString *)text Complete:(void (^)())completeBlock;
/** 启动无限旋转装逼模式 导航栏返回键不可以交互*/
+ (void)show;

/** 转晕了，大千世界不再怀念 */
+ (void)dismiss;

/*************************add by Lance 2017.10.27*************************/

/** 启动无限旋转装逼模式 导航栏返回键不可以交互,携带文字*/
+ (void)showWithInfor:(NSString *)inforStr;

/** 显示错误信息，内置判空操作，并自动显示默认错误文本 ,错误文本为error.userInfo[@"errmsg"] ,
 通过传入aview，判断当前这个aview是不是显示，不显示则不弹出错误信息，避免错误信息在别的界面弹出
 */
+ (void)showWithError:(NSError *)error withView:(UIView *)aview;

@end
