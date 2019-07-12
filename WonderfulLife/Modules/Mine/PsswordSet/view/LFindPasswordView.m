//
//  LFindPasswordView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LFindPasswordView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "MHUserInfoManager.h"
#import "MHHUDManager.h"

@implementation LFindPasswordView

- (id)init{
    self = [super init];
    if(self){
        [self setUpUI];
        
        [self bindSignal];
    }
    return self;
}

- (void)dealloc{
    
}

- (void)setUpUI{
    
    [self codeViewLayout];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = MRGBColor(211, 220, 230);
    
    [self addSubview:self.atitleLable];
    [self addSubview:self.messageLabel];
    [self addSubview:lineView];
    [self addSubview:self.suggestMessageLabel];
    [self addSubview:self.frontNumLabel];
    [self addSubview:self.inputBgView];
    [self addSubview:self.codeBgView];
    [self addSubview:self.sureBtn];
    
    [_atitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-28);
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_atitleLable.mas_bottom).offset(8);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-28);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageLabel.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@.5);
    }];
    [_suggestMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(40.5);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-28);
    }];
    [_frontNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(28);
        make.centerY.equalTo(_inputBgView.mas_centerY);
    }];
    [_inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_suggestMessageLabel.mas_bottom).offset(8);
        make.left.equalTo(_frontNumLabel.mas_right).offset(12);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@46);
    }];
    [_codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputBgView.mas_bottom).offset(24);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@56);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeBgView.mas_bottom).offset(40);
        make.left.equalTo(self.mas_left).offset(28);
        make.right.equalTo(self.mas_right).offset(-28);
        make.height.equalTo(@56);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)codeViewLayout{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = MRGBColor(211, 220, 230);
    [self.codeBgView addSubview:self.signView];
    [self.codeBgView addSubview:self.codeTextF];
    [self.codeBgView addSubview:self.cuntDownBtn];
    [self.codeBgView addSubview:lineView];
    
    [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeBgView.mas_left).offset(18);
        make.centerY.equalTo(_codeBgView.mas_centerY);
        make.width.equalTo(@14);
        make.height.equalTo(@15);
    }];
    
    [_codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_signView.mas_right).offset(12);
        make.centerY.equalTo(_codeBgView.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeTextF.mas_right).offset(5);
        make.centerY.equalTo(_codeBgView.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(@24);
    }];
    
    [_cuntDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(12);
        make.right.equalTo(_codeBgView.mas_right).offset(-7);
        make.centerY.equalTo(_codeBgView.mas_centerY);
        make.height.equalTo(@40);
    }];
    
    
}

- (void)bindSignal{
    RACSignal *lastPhoneNumSignal = RACObserve(self.inputBgView, inputStrig);
    RACSignal *codeSignal = self.codeTextF.rac_textSignal;
    RACSignal *reduceSignal = [RACSignal combineLatest:@[lastPhoneNumSignal,codeSignal] reduce:^id(NSString *lastPhoneNum,NSString *codeNum){
        NSString *phoneNum = [MHUserInfoManager sharedManager].phone_number;
        return @(lastPhoneNum.length == 4 && codeNum.length >= 4 && [lastPhoneNum isEqualToString:[phoneNum substringWithRange:NSMakeRange(phoneNum.length - 4, 4)]]);
    }];
    
    RAC(self.sureBtn,enabled) = reduceSignal;
    self.cuntDownBtn.userInteractionEnabled = NO;
    [lastPhoneNumSignal subscribeNext:^(NSString *x) {
        self.cuntDownBtn.userInteractionEnabled = (x.length == 4);
    }];
    
    [[lastPhoneNumSignal filter:^BOOL(NSString *value) {
        return value.length == 4;
    }] subscribeNext:^(NSString *x) {
        NSString *phoneNum = [MHUserInfoManager sharedManager].phone_number;
        if(phoneNum.length > 4){
            if(![x isEqualToString:[phoneNum substringWithRange:NSMakeRange(phoneNum.length - 4, 4)]]){
                [MHHUDManager showText:@"手机错误，请重新输入" Complete:^{
                    [self.inputBgView clearInput];
                    [self.inputBgView makeFirstResponderIndex:0];
                }];
                
                self.cuntDownBtn.userInteractionEnabled = NO;
            }else{
                self.cuntDownBtn.userInteractionEnabled = YES;
            }
        }
    }];
}

#pragma mark - 定时器 (GCD)
- (void)createTimer {
    
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout = 60;
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    __weak __typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
            //            dispatch_realse(timer);
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.cuntDownBtn.enabled = YES;
                
                [weakSelf.cuntDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.cuntDownBtn.enabled = NO;
                NSString * title = [NSString stringWithFormat:@"%d秒后获取",timeout];
                
                [weakSelf.cuntDownBtn setTitle:title forState:UIControlStateDisabled];
            });
        }
    });
    
    dispatch_resume(timer);
}

#pragma mark - lazyload
- (UILabel *)atitleLable{
    if(!_atitleLable){
        _atitleLable = [UILabel new];
        _atitleLable.textColor = MColorToRGB(0X324057);
        _atitleLable.font = [UIFont boldSystemFontOfSize:MScale * 32];
        _atitleLable.text = @"忘记密码";
    }
    return _atitleLable;
}
- (UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = MRGBColor(132, 146, 166);
        _messageLabel.font = [UIFont systemFontOfSize:MScale * 18];
        _messageLabel.text = @"通过验证手机号和验证码找回密码";
    }
    return _messageLabel;
}
- (UILabel *)suggestMessageLabel{
    if(!_suggestMessageLabel){
        _suggestMessageLabel = [UILabel new];
        _suggestMessageLabel.numberOfLines = 0;
        _suggestMessageLabel.textColor = MRGBColor(71, 86, 105);
        _suggestMessageLabel.font = [UIFont systemFontOfSize:MScale * 17];
        _suggestMessageLabel.text = @"请输入登录时使用的手机后4位，并输入验证码";
    }
    return _suggestMessageLabel;
}
- (UILabel *)frontNumLabel{
    if(!_frontNumLabel){
        _frontNumLabel = [UILabel new];
        _frontNumLabel.textColor = MRGBColor(71, 86, 105);
        _frontNumLabel.font = [UIFont systemFontOfSize:MScale * 24];
        
    }
    return _frontNumLabel;
}

- (LPasswordView *)inputBgView{
    if(!_inputBgView){
        _inputBgView = [[LPasswordView alloc] initWithInputNum:4 titleName:nil];
    }
    return _inputBgView;
}
- (UIView *)codeBgView{
    if(!_codeBgView){
        _codeBgView = [UIView new];
        _codeBgView.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
        _codeBgView.layer.borderWidth = 1;
        _codeBgView.layer.cornerRadius = 3;
        _codeBgView.layer.masksToBounds = YES;
    }
    return _codeBgView;
}
- (UIImageView *)signView{
    if(!_signView){
        _signView = [UIImageView new];
        _signView.image = [UIImage imageNamed:@"lo_verification"];
        _signView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _signView;
}
- (UITextField *)codeTextF{
    if(!_codeTextF){
        _codeTextF = [UITextField new];
        _codeTextF.textColor = MRGBColor(50, 64, 87);
        _codeTextF.font = [UIFont systemFontOfSize:MScale * 17];
        _codeTextF.placeholder = @"短信验证码";
        _codeTextF.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextF setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _codeTextF;
}
- (UIButton *)cuntDownBtn{
    if(!_cuntDownBtn){
        _cuntDownBtn = [UIButton new];
        _cuntDownBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 14];
        [_cuntDownBtn setTitleColor:MRGBColor(255, 73, 73) forState:UIControlStateNormal];
        [_cuntDownBtn setTitleColor:MRGBColor(192 ,204, 218) forState:UIControlStateDisabled];
        [_cuntDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        @weakify(self);
        [[_cuntDownBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSString *phoneNum = [MHUserInfoManager sharedManager].phone_number;
            [self.codeGetSubject sendNext:phoneNum];
        }];
    }
    return _cuntDownBtn;
}

- (MHThemeButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 16];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:MRGBColor(229, 233, 242)];
        [_sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
        @weakify(self);
        [[_sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSString *phoneNum = [MHUserInfoManager sharedManager].phone_number;
            NSString *smsCode = self.codeTextF.text;
            [self.codeValiteSubject sendNext:@{@"phone":phoneNum,@"sms_code":smsCode}];
            
        }];
    }
    return _sureBtn;
}

- (RACSubject *)codeGetSubject{
    if(!_codeGetSubject){
        _codeGetSubject = [RACSubject subject];
    }
    return _codeGetSubject;
}
- (RACSubject *)codeValiteSubject{
    if(!_codeValiteSubject){
        _codeValiteSubject = [RACSubject subject];
    }
    return _codeValiteSubject;
}

@end
