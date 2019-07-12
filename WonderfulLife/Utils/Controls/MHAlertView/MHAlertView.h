//
//  MHAlertView.h
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHNormalActionSheet.h"
#import "MHTitleActionSheet.h"
#import "MHNormalAlertView.h"
#import "MHNormalTitleAlertView.h"
#import "MHMessageAlertView.h"
#import "MHTextFieldAlertView.h"

@interface MHAlertView : UIView
/**
 MHAlertView单例对象
 */
+ (instancetype)sharedInstance;

/**
 显示默认样式中间提醒框
 */
- (void)showNormalAlertViewTitle:(NSString *)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

/**
 显示默认样式中间提醒框,按钮标题可修改
 */
- (void)normalAlertViewTitle:(NSString *)title message:(NSString *)message LeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

/** 普通提示框，只有标题*/
- (void)showNormalTitleAlertViewWithTitle:(NSString *)title  leftHandler:(NormalTitleAlertViewLeftHandler)leftHandler rightHandler:(NormalTitleAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

/**
 显示标题样式中间提醒框
 */
- (MHMessageAlertView *)showMessageAlertViewTitle:(NSString *)title message:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler;

/**
 显示文本框样式中间提醒框
 */
- (void)showTextFieldAlertViewTitle:(NSString *)title sureHandler:(TextFidleAlertViewSureHandler)sureHandler cancelHandler:(TextFieldAlertViewCancelHandler)cancelHandler;

/**
 显示默认样式底部提醒框
 */
- (void)showNormalActionSheetTitle:(NSString *)title topHandler:(NormalActionSheetTopHandler)topHandler bottomTitle:(NSString *)bottomTitle bottomHandler:(NormalActionSheetBottomHandler)bottomHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(NormalActionSheetCancelHandler)cancelHandler cancelColor:(UIColor *)cancelColor;

/**
 显示标题样式底部提醒框
 */
- (void)showTitleActionSheetTitle:(NSString *)title sureHandler:(TitleActionSheetSureHandler)sureHandler cancelHandler:(TitleActionSheetCancelHandler)cancelHandler sureButtonColor:(UIColor *)sureButtonColor sureButtonTitle:(NSString *)sureButtonTitle;

/**
 版本更新(需要更新)
 */
- (void)showVersionAlertViewMessage:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

/**
 版本更新(强制更新)
 */
+ (void)showVersionAlertViewMessage:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler;


/**
 单个按钮提示窗
 */
+ (void)showMessageAlertViewMessage:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler;

/**
 单个按钮提示窗,自定义确定文字
 */
+ (void)showMessageAlertViewMessage:(NSString *)message ConfirmName:(NSString *)confirmName sureHandler:(MessageAlertViewSureHandler)sureHandler;

/**
 标题，内容 字体颜色相同
 */
- (void)showSameTextColorAlertViewTitle:(NSString*)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

/**
 移除提醒框
 */
- (void)dismiss;

@end
