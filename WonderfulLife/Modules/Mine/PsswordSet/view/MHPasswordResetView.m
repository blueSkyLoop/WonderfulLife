//
//  MHPasswordResetView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHPasswordResetView.h"
#import "MHMacros.h"
#import "Masonry.h"

@interface MHPasswordResetView()

@property (nonatomic,strong,readwrite)RACSubject *passwordResetSubject;

@end

@implementation MHPasswordResetView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
//    UIView *lineTop = [UIView new];
//    lineTop.backgroundColor = MColorSeparator;
    UIView *lineBottom = [UIView new];
    lineBottom.backgroundColor = MColorSeparator;
    
    UILabel *atitleLabel = [UILabel new];
    atitleLabel.backgroundColor = [UIColor clearColor];
    atitleLabel.font = [UIFont systemFontOfSize:17 * MScale];
    atitleLabel.textColor = MRGBColor(50, 64, 87);
    atitleLabel.text = @"重置积分支付密码";
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"common_right_arrow"];
//    [self addSubview:lineTop];
    [self addSubview:lineBottom];
    [self addSubview:atitleLabel];
    [self addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self.passwordResetSubject sendNext:nil];
        
    }];
    [self addGestureRecognizer:tap];
    
//    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.mas_top).offset(1);
//        make.height.equalTo(@.5);
//    }];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@.5);
    }];
    [atitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(24);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(atitleLabel.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-24);
        make.centerY.equalTo(self.mas_centerY);
    }];

}

- (RACSubject *)passwordResetSubject{
    if(!_passwordResetSubject){
        _passwordResetSubject = [RACSubject subject];
    }
    return _passwordResetSubject;
}

@end
