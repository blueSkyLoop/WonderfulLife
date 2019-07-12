//
//  MHMessageAlertView.h
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MessageAlertViewSureHandler)(void);  // 确定按钮点击

@interface MHMessageAlertView : UIView
/*
 * 确定回调
 */
@property (nonatomic, copy) MessageAlertViewSureHandler sureHandler;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint;

/*
 * 标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/*
 * 消息Label
 */
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/** 确定按钮*/
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

/**
 标题样式中间提醒框
 */
+ (instancetype)messageAlertViewTitle:(NSString *)title message:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler;
+ (instancetype)messageAlertViewTitle:(NSString *)title message:(NSString *)message ConfirmName:(NSString *)confirmName sureHandler:(MessageAlertViewSureHandler)sureHandler;

@end
