//
//  LPasswordSetNewView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordSetNewView.h"
#import "Masonry.h"
#import "MHMacros.h"

@implementation LPasswordSetNewView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.atitleLable];
    [self addSubview:self.inputBgView];
    [self addSubview:self.reInputBgView];
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
    [_reInputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputBgView.mas_bottom).offset(24);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@92);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
//    RACSignal *signal1 = RACObserve(self, payPassword);
//    RACSignal *signal2 = RACObserve(self, payPassword);
//    //先组合再聚合
//    //reduce后的参数需要自己添加,添加以前方传来的信号的数据为准
//    //return类似映射,可以对数据进行处理再发送给订阅者
//    RACSignal * reduceSignal = [RACSignal combineLatest:@[signal1,signal2] reduce:^id(NSString * name,NSString * age){
//        
//        return [NSString stringWithFormat:@"姓名:%@,年龄:%@",name,age];
//        
//    }];
//    
//    [[reduceSignal filter:^BOOL(NSString * value) {
//        return value.length >= 6;
//    }] subscribeNext:^(id  _Nullable x) {
//        
//    }];
    
   
    
}
- (void)clearAllInput{
    [self.inputBgView clearInput];
    [self.reInputBgView clearInput];
}


#pragma mark - lazy load
- (UILabel *)atitleLable{
    if(!_atitleLable){
        _atitleLable = [UILabel new];
        _atitleLable.textColor = MColorToRGB(0X324057);;
        _atitleLable.font = [UIFont boldSystemFontOfSize:MScale * 32];
        _atitleLable.text = @"设置新密码";
    }
    return _atitleLable;
}

- (LPasswordView *)inputBgView{
    if(!_inputBgView){
        _inputBgView = [[LPasswordView alloc] initWithInputNum:6 titleName:@"输入支付密码"];
    }
    return _inputBgView;
}
- (LPasswordView *)reInputBgView{
    if(!_reInputBgView){
        _reInputBgView = [[LPasswordView alloc] initWithInputNum:6 titleName:@"重复支付密码"];
    }
    return _reInputBgView;
}


@end
