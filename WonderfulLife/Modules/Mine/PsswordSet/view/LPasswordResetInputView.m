//
//  LPasswordResetInputView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordResetInputView.h"
#import "Masonry.h"
#import "MHMacros.h"

@implementation LPasswordResetInputView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
        
        [self setConfig];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.atitleLable];
    [self addSubview:self.inputBgView];
    [self addSubview:self.forgetBtn];
    [_atitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-28);
    }];
    [_inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_atitleLable.mas_bottom).offset(32);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@92);
    }];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputBgView.mas_bottom).offset(24);
        make.right.equalTo(self.mas_right).offset(-28);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setConfig{
   
}


#pragma mark - lazy load
- (UILabel *)atitleLable{
    if(!_atitleLable){
        _atitleLable = [UILabel new];
        _atitleLable.textColor = MRGBColor(50, 64, 87);
        _atitleLable.font = [UIFont boldSystemFontOfSize:MScale * 32];
        _atitleLable.text = @"重置积分支付密码";
    }
    return _atitleLable;
}

- (LPasswordView *)inputBgView{
    if(!_inputBgView){
        _inputBgView = [[LPasswordView alloc] initWithInputNum:6 titleName:@"输入原支付密码"];
    }
    return _inputBgView;
}

- (UIButton *)forgetBtn{
    if(!_forgetBtn){
        _forgetBtn = [UIButton new];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 16];
        [_forgetBtn setTitleColor:MRGBColor(32, 160, 255) forState:UIControlStateNormal];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        @weakify(self);
        [[_forgetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.forgetPasswordSubject sendNext:nil];
        }];
    }
    return _forgetBtn;
}
- (RACSubject *)forgetPasswordSubject{
    if(!_forgetPasswordSubject){
        _forgetPasswordSubject = [RACSubject subject];
    }
    return _forgetPasswordSubject;
}

@end
