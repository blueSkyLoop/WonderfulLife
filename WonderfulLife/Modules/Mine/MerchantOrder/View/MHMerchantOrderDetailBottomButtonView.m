//
//  MHMerchantOrderDetailBottomButtonView.m
//  WonderfulLife
//
//  Created by zz on 27/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailBottomButtonView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIImage+Color.h"

#import "MHAlertView.h"
#import "MHWeakStrongDefine.h"

@interface MHMerchantOrderDetailBottomButtonView ()
@property (nonatomic, strong)UIButton *normalButton;
@property (nonatomic, strong)UIButton *refundButton;

@end

@implementation MHMerchantOrderDetailBottomButtonView

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = MColorToRGB(0XF9FAFC);
    }
    return self;
}

- (void)setType:(MHMerchantOrderBottomButtonType)type {
    _type = type;
    switch (type) {
        case MHMerchantOrderBottomButtonTypeUnused:
            self.frame = CGRectMake(0,0, MScreenW, 116);
            [self layoutRefundButton];
            break;
        case MHMerchantOrderBottomButtonTypeChecking:
            self.frame = CGRectMake(0,MScreenH - 124, MScreenW, 60);
            [self layoutCheckingButtons];
            break;
        case MHMerchantOrderBottomButtonTypeReviews:
            self.frame = CGRectMake(0, 0, MScreenW, 116);
            [self layoutThemeButton];
            break;
        case MHMerchantOrderBottomButtonTypeRefund:
            self.frame = CGRectMake(0, 0, MScreenW, 116);
            [self layoutRefundAndUnusedButton];
            break;
        case MHMerchantOrderBottomButtonTypeUnpaid:
            self.frame = CGRectMake(0, 0, MScreenW, 116);
            [self layoutUnpaidButton];
            break;
        default:
            break;
    }
}

- (void)layoutUnpaidButton {
    [self.themeButton addTarget:self action:@selector(firstButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self.themeButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self addSubview:self.themeButton];
    [self.themeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(24);
        make.right.mas_equalTo(-24).priorityMedium();
        make.height.mas_equalTo(56);
    }];
}

- (void)layoutRefundButton {
    [self.normalButton addTarget:self action:@selector(firstButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.normalButton];
    [self.normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(24);
        make.right.mas_equalTo(-24).priorityMedium();
        make.height.mas_equalTo(56);
    }];

}

- (void)layoutThemeButton {
    [self.themeButton addTarget:self action:@selector(firstButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    self.themeButton.enabled = NO;
    [self addSubview:self.themeButton];
    [self.themeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(24);
        make.right.mas_equalTo(-24).priorityMedium();
        make.height.mas_equalTo(56);
    }];
}

- (void)layoutRefundAndUnusedButton {
    [self.normalButton addTarget:self action:@selector(firstButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
//    [self.themeButton addTarget:self action:@selector(sendButtonCallphoneEvents:) forControlEvents:UIControlEventTouchUpInside];
//    [self.themeButton setTitle:@"拨打客户电话" forState:UIControlStateNormal];
    [self addSubview:self.normalButton];
//    [self addSubview:self.themeButton];
    
    [self.normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(24);
        make.right.mas_equalTo(-24).priorityMedium();
        make.height.mas_equalTo(56);
    }];
    
//    [self.themeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(24);
//        make.top.mas_equalTo(self.normalButton.mas_bottom).mas_offset(16);
//        make.right.mas_equalTo(-24).priorityMedium();
//        make.height.mas_equalTo(56);
//    }];

}

- (void)layoutCheckingButtons {
    UIButton *leftButton = [self newButton:@"拒 绝" colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];
    UIButton *rightButton = [self newButton:@"同 意" colors:@[MColorToRGB(0X00E3AE),MColorToRGB(0X9BE15D)]];
    [leftButton addTarget:self action:@selector(firstButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(secondButtonEvents:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:rightButton];
    [self addSubview:leftButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(self);
        make.right.mas_equalTo(rightButton.mas_left);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftButton.mas_right);
        make.right.bottom.top.mas_equalTo(self);
        make.width.mas_equalTo(leftButton.mas_width);
    }];
}

- (UIButton *)newButton:(NSString*)title colors:(NSArray*)colors{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightSemibold];
    CGRect rect = CGRectMake(0, 0, MScreenW/2, 60);
    [button setBackgroundImage:[UIImage mh_gradientImageWithBounds:rect direction:UIImageGradientDirectionRight colors:colors] forState:UIControlStateNormal];
    return button;
}

#pragma mark - Action Method
- (void)firstButtonEvents:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(MerchantOrderDetailBottomButtonType:leftButtonClick:rightButtonClick:)]) {
        [self.delegate MerchantOrderDetailBottomButtonType:self.type leftButtonClick:YES rightButtonClick:NO];
    }
}

- (void)secondButtonEvents:(UIButton *)sender {
    
    MHWeakify(self);
    [[MHAlertView sharedInstance]showSameTextColorAlertViewTitle:@"确定退款？" message:@"确定退款后将把款项返回给用户" leftHandler:^{
        [[MHAlertView sharedInstance] dismiss];
    } rightHandler:^{
        MHStrongify(self);
        [[MHAlertView sharedInstance] dismiss];
        if ([self.delegate respondsToSelector:@selector(MerchantOrderDetailBottomButtonType:leftButtonClick:rightButtonClick:)]) {
            [self.delegate MerchantOrderDetailBottomButtonType:self.type leftButtonClick:NO rightButtonClick:YES];
        }
    } rightButtonColor:MColorToRGB(0X20A0FF)];
}

- (void)sendButtonCallphoneEvents:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(MerchantOrderDetailBottomButtonType:leftButtonClick:rightButtonClick:)]) {
        [self.delegate MerchantOrderDetailBottomButtonType:self.type leftButtonClick:NO rightButtonClick:YES];
    }
}

#pragma mark - Getter
- (MHThemeButton *)themeButton {
    if (!_themeButton) {
        _themeButton = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, 0, MScreenW - 48, 56)];
        [_themeButton setTitle:@"提交评论" forState:UIControlStateNormal];
        [_themeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _themeButton;
}

- (UIButton *)refundButton {
    if (!_refundButton) {
        _refundButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_refundButton setTitle:@"退 款" forState:UIControlStateNormal];
        [_refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refundButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _refundButton.backgroundColor = MColorToRGB(0XE5E9F2);
        _refundButton.layer.cornerRadius = 2.f;
        _refundButton.layer.masksToBounds = YES;
    }
    return _refundButton;
}

- (UIButton *)normalButton {
    if (!_normalButton) {
        _normalButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_normalButton setTitle:@"退 款" forState:UIControlStateNormal];
        [_normalButton setTitleColor:MColorToRGB(0X324057) forState:UIControlStateNormal];
        _normalButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        //设置圆角和边框色
        _normalButton.layer.cornerRadius = 2.f;
        _normalButton.layer.masksToBounds = YES;
        _normalButton.layer.borderWidth = 1.f;
        _normalButton.layer.borderColor = MColorToRGB(0XD3DCE6).CGColor;
        //设置阴影
        _normalButton.layer.shadowOffset = CGSizeMake(0, 2);
        _normalButton.layer.shadowRadius = 5;
        _normalButton.layer.shadowColor = MColorShadow.CGColor;
        _normalButton.layer.shadowOpacity = 1;
        _normalButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _normalButton;
}


@end
