//
//  MHPayChooseView.m
//  WonderfulLife
//
//  Created by lgh on 2018/1/4.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHPayChooseView.h"
#import "ReactiveObjC.h"

@interface MHPayChooseView()

@property (nonatomic,assign)BOOL wechatHidden;

@end

@implementation MHPayChooseView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    
    self.totalLabel.font = MHSFont(28);
    
    // 设置四周阴影
    self.totalBackgroundView.layer.borderColor = MColorToRGB(0XEFF2F7).CGColor;
    self.totalBackgroundView.layer.borderWidth = 2;
    self.totalBackgroundView.layer.cornerRadius = 6;
    self.totalBackgroundView.layer.masksToBounds = YES;
    
    // 设置确认支付四周阴影
    self.payButton.layer.borderColor = MColorToRGBWithAlpha(0XFF4949, 0.35).CGColor;
    self.payButton.layer.borderWidth = 2;
    
    //默认选中微信支付
    self.weChatImageView.highlighted = YES;
    self.payType = MHHomePayChooseTypeWeChat;
    
    [self addGesAction];
    
}

- (void)addGesAction{
    @weakify(self);
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [[tap1.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        self.aliImageView.highlighted = NO;
        self.weChatImageView.highlighted = YES;
        self.payType = MHHomePayChooseTypeWeChat;
    }];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    [[tap2.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        self.aliImageView.highlighted = YES;
        self.weChatImageView.highlighted = NO;
        self.payType = MHHomePayChooseTypeAliPay;
    }];
    
    [self.wechatBgView addGestureRecognizer:tap1];
    [self.aliBgView addGestureRecognizer:tap2];
}

//设置支付宝和微信支付选项是否可以选择
- (void)payChooseShow:(BOOL)show{
    CGFloat height = show?72:0;
    self.layoutHeight1.constant = self.wechatHidden?0:height;
    self.layoutHeight2.constant = height;
    self.layoutGap.constant = show?24:0.5;
}

- (void)hiddenWechat{
    self.aliImageView.highlighted = YES;
    self.weChatImageView.highlighted = NO;
    self.payType = MHHomePayChooseTypeAliPay;
    self.layoutHeight1.constant = 0;
    self.wechatHidden = YES;
}


@end
