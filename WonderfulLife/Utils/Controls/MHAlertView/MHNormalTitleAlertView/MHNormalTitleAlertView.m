//
//  MHNormalTitleAlertView.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHNormalTitleAlertView.h"
#import "MHAlertView.h"

@implementation MHNormalTitleAlertView

+ (instancetype)normalTitleAlertViewWithTitle:(NSString *)title  leftHandler:(NormalTitleAlertViewLeftHandler)leftHandler rightHandler:(NormalTitleAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor{
    
    // 1. 创建
    MHNormalTitleAlertView *norTitleAlertView = [MHNormalTitleAlertView loadNormalAlertView];
    
    // 2. 设置属性
    if (rightColor != nil) {
        [norTitleAlertView.rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    }
    norTitleAlertView.titleLabel.text = title;
    norTitleAlertView.rightHandler = rightHandler;
    norTitleAlertView.leftHandler = leftHandler;
    
    // 3. 返回
    return norTitleAlertView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

/**
 加载默认样式中间提醒框
 */
+ (instancetype)loadNormalAlertView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
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

@end
