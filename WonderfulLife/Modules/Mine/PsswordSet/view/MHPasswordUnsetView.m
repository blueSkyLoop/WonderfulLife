//
//  MHPasswordUnsetView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHPasswordUnsetView.h"
#import "MHMacros.h"
#import "Masonry.h"

@interface MHPasswordUnsetView ()

@property (nonatomic,strong,readwrite)RACSubject *passwordSetSubject;

@end

@implementation MHPasswordUnsetView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"ps_set_key"];
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:17 * MScale];
    messageLabel.textColor = MRGBColor(50, 64, 87);
    messageLabel.text = @"您还未设置积分支付密码";
    
    UIButton *setPasswordBtn = [UIButton new];
    setPasswordBtn.layer.cornerRadius = 3;
    setPasswordBtn.layer.masksToBounds = YES;
    setPasswordBtn.layer.borderWidth = 1.0;
    setPasswordBtn.layer.borderColor = [MRGBColor(32, 160, 255) CGColor];
    setPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 19];
    [setPasswordBtn setTitleColor:MRGBColor(32, 160, 255) forState:UIControlStateNormal];
    [setPasswordBtn setTitle:@"设置积分支付密码" forState:UIControlStateNormal];
    [[setPasswordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.passwordSetSubject sendNext:nil];
    }];
    [self addSubview:imageView];
    [self addSubview:messageLabel];
    [self addSubview:setPasswordBtn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.greaterThanOrEqualTo(self.mas_left);
        make.right.lessThanOrEqualTo(self.mas_right);
        make.centerX.equalTo(self.mas_centerX).priorityHigh();
    }];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(42);
        make.left.greaterThanOrEqualTo(self.mas_left);
        make.right.lessThanOrEqualTo(self.mas_right);
        make.centerX.equalTo(self.mas_centerX).priorityHigh();
    }];
    [setPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).offset(24);
        make.width.greaterThanOrEqualTo(messageLabel.mas_width).offset(20);
        make.height.equalTo(@56);
        make.centerX.equalTo(self.mas_centerX).priorityHigh();
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (RACSubject *)passwordSetSubject{
    if(!_passwordSetSubject){
        _passwordSetSubject = [RACSubject subject];
    }
    return _passwordSetSubject;
}

@end
