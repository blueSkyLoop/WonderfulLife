//
//  MHPayChooseView.h
//  WonderfulLife
//
//  Created by lgh on 2018/1/4.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"
#import "MHThemeButton.h"

typedef NS_ENUM(NSUInteger, MHHomePayChooseType) {
    MHHomePayChooseTypeWeChat = 0,  // 微信支付
    MHHomePayChooseTypeAliPay  // 支付宝支付
};

@interface MHPayChooseView : MHBaseView

/**
 总计支付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/**
 总计支付金额背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *totalBackgroundView;
/**
 选中支付类型
 */
@property (assign, nonatomic) MHHomePayChooseType payType;

@property (nonatomic,weak) IBOutlet UIImageView *weChatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aliImageView;

/**
 确认支付按钮
 */
@property (weak, nonatomic) IBOutlet MHThemeButton *payButton;


@property (weak, nonatomic) IBOutlet UILabel *deductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UIButton *intergralChooseBtn;
@property (weak, nonatomic) IBOutlet UIView *wechatBgView;
@property (weak, nonatomic) IBOutlet UIView *aliBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutGap;

//设置支付宝和微信支付选项是否可以选择
- (void)payChooseShow:(BOOL)show;

- (void)hiddenWechat;

@end
