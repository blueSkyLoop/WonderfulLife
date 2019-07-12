//
//  MHTextFieldAlertView.m
//  01-封装提示框
//
//  Created by hehuafeng on 2017/7/21.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHTextFieldAlertView.h"
#import "MHTextField.h"
#import "MHAlertView.h"

#define MColorToRGB(value) MColorToRGBWithAlpha(value, 1.0f)
#define MColorToRGBWithAlpha(value, alpha1) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha1]//十六进制转RGB色

@interface MHTextFieldAlertView () <UITextFieldDelegate>
/**
 文本框
 */
@property (weak, nonatomic) IBOutlet MHTextField *textField;
/**
 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
/**
 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MHTextFieldAlertView
/**
 文本框样式中间提醒框
 */
+ (instancetype)textFieldAlertViewTitle:(NSString *)title sureHandler:(TextFidleAlertViewSureHandler)sureHandler cancelHandler:(TextFieldAlertViewCancelHandler)cancelHandler {
    // 1. 创建
    MHTextFieldAlertView *textFieldAlertView = [MHTextFieldAlertView loadTextFieldAlertView];
    
    // 2. 设置属性
    textFieldAlertView.titleLabel.text = title;
    textFieldAlertView.sureHandler = sureHandler;
    textFieldAlertView.cancelHandler = cancelHandler;
    
    // 3. 返回
    return textFieldAlertView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

/**
 加载文本框样式提醒框
 */
+ (instancetype)loadTextFieldAlertView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

#pragma mark - 点击事件
/**
 取消按钮
 */
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

/**
 确定按钮
 */
- (IBAction)sureButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.sureHandler) {
        self.sureHandler(self.textField.text);
    }
}

#pragma mark - UITextFieldDelegate
/**
 文本框成为第一响应者
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.sureButton setTitleColor:MColorToRGB(0X20A0FF) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y - 40);
    }];
}

/**
 文本框是否允许显示输入文字
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"string: %@", string);
    if (textField.text.length > 8 && string.length > 0) {
        return NO;
    }else {
        return YES;
    }
}


@end
