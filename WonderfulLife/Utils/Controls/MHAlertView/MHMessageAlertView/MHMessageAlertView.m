//
//  MHMessageAlertView.m
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHMessageAlertView.h"
#import "MHAlertView.h"

@interface MHMessageAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation MHMessageAlertView
/**
 标题样式中间提醒框
 */
+ (instancetype)messageAlertViewTitle:(NSString *)title message:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 1. 创建标题中间提示框
    MHMessageAlertView *messageAlertView = [MHMessageAlertView loadMessageAlertView];
    
    // 2. 设置属性
    messageAlertView.titleLabel.text = title;
    messageAlertView.messageLabel.text = message;
    messageAlertView.sureHandler = sureHandler;
    
    // 3. 返回
    return messageAlertView;
}

+ (instancetype)messageAlertViewTitle:(NSString *)title message:(NSString *)message ConfirmName:(NSString *)confirmName sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 1. 创建标题中间提示框
    MHMessageAlertView *messageAlertView = [MHMessageAlertView loadMessageAlertView];
    
    // 2. 设置属性
    messageAlertView.titleLabel.text = title;
    messageAlertView.messageLabel.text = message;
    [messageAlertView.confirmButton setTitle:confirmName forState:UIControlStateNormal];
    messageAlertView.sureHandler = sureHandler;
    
    // 3. 返回
    return messageAlertView;
}

/*
 加载标题样式中间提醒框
 */
+ (instancetype)loadMessageAlertView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

#pragma mark - 点击事件
/*
 *  确定按钮点击事件
 */
- (IBAction)sureButtonClick:(UIButton *)button {
    [[MHAlertView sharedInstance] dismiss];
    if (self.sureHandler) {
        self.sureHandler();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
