//
//  MHHomePayBottomView.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayBottomView.h"

#import "MHMacros.h"
#import "UIImage+Color.h"

@interface MHHomePayBottomView ()


@end

@implementation MHHomePayBottomView
/**
 加载物业缴费底部工具栏
 */
+ (instancetype)loadHomePayBottomView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置外阴影
    self.layer.shadowColor = MRGBColor(0, 0, 0).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowRadius = 2;
    
    // 禁用autoresizingMask
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 设置button属性
    [self.payButton setBackgroundImage:[UIImage mh_imageGradientSetMainColorWithBounds:self.bounds] forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:[UIImage mh_imageGradientSetMainColorWithBounds:self.bounds] forState:UIControlStateHighlighted];
    [self.payButton setBackgroundImage:[UIImage mh_imageWithColor:MRGBColor(239, 242, 247)] forState:UIControlStateDisabled];
}

#pragma mark - 按钮点击事件
- (IBAction)payButtonClick:(UIButton *)sender {
    if (self.payHandler != nil) {
        self.payHandler();
    }
}


@end
