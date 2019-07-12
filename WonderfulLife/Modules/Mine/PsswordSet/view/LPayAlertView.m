//
//  LPayAlertView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPayAlertView.h"
#import "Masonry.h"
#import "MHMacros.h"

@interface LPayAlertView()
@property (nonatomic,assign)BOOL animating;
@property (nonatomic,copy)void(^compleBlock)(PayActionType type,NSString *passwordStr);
@property (nonatomic,copy)NSString *passwordStr;
@end

@implementation LPayAlertView

- (id)initWithPayComple:(void(^)(PayActionType type,NSString *passwordStr))comple{
    self = [super init];
    if(self){
        self.compleBlock = [comple copy];
        [self setUpUI];
        
        [self setConfig];
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    CGFloat keyboardHeight = MScreenW > 375?226:216;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor clearColor];
    UIView *abackgroudView = [UIView new];
    abackgroudView.backgroundColor = [UIColor clearColor];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [UIView new];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = MRGBColor(211, 220, 230);
    [topView addSubview:self.backBtn];
    [topView addSubview:self.atitleLable];
    [bgView addSubview:topView];
    [bgView addSubview:lineView];
    [bgView addSubview:self.inputBgView];
    [bgView addSubview:self.forgetBtn];
    [abackgroudView addSubview:bgView];
    [scrollView addSubview:abackgroudView];
    [self addSubview:scrollView];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(10);
    }];
    [_atitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX).priorityHigh();
        make.left.greaterThanOrEqualTo(_backBtn.mas_right).offset(10);
        make.right.lessThanOrEqualTo(topView.mas_right).offset(-10);
    }];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@44);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@1);
    }];
    [_inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(33);
        make.left.equalTo(bgView.mas_left).offset(28);
        make.right.equalTo(bgView.mas_right).offset(-28);
        make.height.equalTo(@52);
    }];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputBgView.mas_bottom).offset(24);
        make.right.equalTo(bgView.mas_right).offset(-37);
        make.bottom.equalTo(bgView.mas_bottom).offset(-(keyboardHeight + 55));
    }];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(abackgroudView.mas_top);
        make.left.equalTo(abackgroudView.mas_left);
        make.right.equalTo(abackgroudView.mas_right);
        make.bottom.equalTo(abackgroudView.mas_bottom);
    }];
    [abackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.equalTo(scrollView.mas_left);
        make.right.equalTo(scrollView.mas_right);
        make.bottom.equalTo(scrollView.mas_bottom);
        make.width.equalTo(scrollView.mas_width);
        make.height.greaterThanOrEqualTo(@(MScreenH));
        
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setConfig{
    @weakify(self);
    [RACObserve(self.inputBgView, inputStrig) subscribeNext:^(NSString *x) {
        @strongify(self);
        self.passwordStr = x;
    }];
}

- (void)show{
    
    __block CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.frame = rect;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        rect.origin.y = 0;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self.inputBgView makeFirstResponderIndex:0];
    }];
}
- (void)hiddenAlert{
    
    [self hiddenAlertWithAnimated:YES];
    
}

- (void)hiddenAlertWithAnimated:(BOOL)animated{
    if(animated){
        if(self.animating) return;
        __block CGRect rect = self.frame;
        self.animating = YES;
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.y = [UIScreen mainScreen].bounds.size.height;
            self.frame = rect;
        } completion:^(BOOL finished) {
            self.animating = NO;
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}



#pragma mark - lazy load
- (UILabel *)atitleLable{
    if(!_atitleLable){
        _atitleLable = [UILabel new];
        _atitleLable.textColor = MRGBColor(50, 64, 87);
        _atitleLable.font = [UIFont systemFontOfSize:MScale * 19];
        _atitleLable.text = @"请输入支付密码";
    }
    return _atitleLable;
}
- (UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        @weakify(self);
        [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.compleBlock){
                self.compleBlock(Pay_back, nil);
            }
            [self hiddenAlert];
        }];
    }
    return _backBtn;
}

- (LPasswordView *)inputBgView{
    if(!_inputBgView){
        _inputBgView = [[LPasswordView alloc] initWithInputNum:6 titleName:nil];
        @weakify(self);
        _inputBgView.passwordInputCompleBlock = ^{
            @strongify(self);
            if(self.compleBlock){
                self.compleBlock(Pay_inputPasswordComple, self.passwordStr);
            }
        };
    }
    return _inputBgView;
}

- (UIButton *)forgetBtn{
    if(!_forgetBtn){
        _forgetBtn = [UIButton new];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 17];
        [_forgetBtn setTitleColor:MRGBColor(32, 160, 255) forState:UIControlStateNormal];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        @weakify(self);
        [[_forgetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.compleBlock){
                self.compleBlock(Pay_forgetPassword, nil);
            }
            [self hiddenAlertWithAnimated:NO];
        }];
    }
    return _forgetBtn;
}



@end
