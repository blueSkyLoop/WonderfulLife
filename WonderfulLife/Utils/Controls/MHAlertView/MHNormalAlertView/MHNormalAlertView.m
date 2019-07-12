//
//  MHAlertView.m
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHNormalAlertView.h"
#import "MHAlertView.h"

@interface MHNormalAlertView ()


@end

@implementation MHNormalAlertView
/**
 默认样式中间提醒框
 */
+ (instancetype)normalAlertViewTitle:(NSString *)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor {
    // 1. 创建
    MHNormalAlertView *norAlertView = [MHNormalAlertView loadNormalAlertView];
    
    // 2. 设置属性
    if (rightColor != nil) {
        [norAlertView.rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    }
    norAlertView.titleLabel.text = title;
    norAlertView.contentLabel.text = message;
    norAlertView.rightHandler = rightHandler;
    norAlertView.leftHandler = leftHandler;
    
    // 3. 返回
    return norAlertView;
}

+ (instancetype)normalAlertViewTitle:(NSString *)title message:(NSString *)message LeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor {
    // 1. 创建
    MHNormalAlertView *norAlertView = [MHNormalAlertView loadNormalAlertView];
    
    // 2. 设置属性
    if (rightColor != nil) {
        [norAlertView.rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    }
    [norAlertView.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [norAlertView.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    
    norAlertView.titleLabel.text = title;
    norAlertView.contentLabel.text = message;
    norAlertView.rightHandler = rightHandler;
    norAlertView.leftHandler = leftHandler;
    
    // 3. 返回
    return norAlertView;
}

/**
 加载默认样式中间提醒框
 */
+ (instancetype)loadNormalAlertView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

#pragma mark - 点击事件
/**
 *  确定按钮响应事件
 */
- (IBAction)sureButtonClick:(UIButton *)button {
    // 添加取消
    [[MHAlertView sharedInstance] dismiss];
    if (self.rightHandler) {
        self.rightHandler();
    }
}

/**
 *  取消按钮响应事件
 */
- (IBAction)cancelButtonClick:(UIButton *)button {
    [[MHAlertView sharedInstance] dismiss];
    if (self.leftHandler) {
        self.leftHandler();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
