//
//  MHIntegralsPayAlertView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHIntegralsPayAlertView.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

@interface MHIntegralsPayAlertView()

@property (nonatomic,copy)void(^compleBlock)(NSInteger buttonIndex);
@property (nonatomic,assign)BOOL animating;
@property (nonatomic,assign)IntegralsPayFailuretType type;

@end

@implementation MHIntegralsPayAlertView

- (id)initWithPaySuggestType:(IntegralsPayFailuretType)type comple:(void(^)(NSInteger buttonIndex))comple{
    self = [super init];
    if(self){
        self.type = type;
        self.compleBlock = [comple copy];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 2;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    [bgView addSubview:self.suggestImageView];
    [bgView addSubview:self.suggestLabel];
    [bgView addSubview:self.button];
    if(self.type == IntegralsPayFailuret_notVolunteer){
        [bgView addSubview:self.knowButton];
    }
    
    [_suggestImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        make.top.equalTo(bgView.mas_top).offset(56);
        make.left.greaterThanOrEqualTo(bgView.mas_left).offset(24);
        make.right.lessThanOrEqualTo(bgView.mas_right).offset(-24);
    }];
    
    [_suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        make.top.equalTo(_suggestImageView.mas_bottom).offset(23);
        make.left.greaterThanOrEqualTo(bgView.mas_left).offset(24);
        make.right.lessThanOrEqualTo(bgView.mas_right).offset(-24);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        make.top.equalTo(_suggestLabel.mas_bottom).offset(48);
        make.left.greaterThanOrEqualTo(bgView.mas_left).offset(24);
        make.right.lessThanOrEqualTo(bgView.mas_right).offset(-24);
        make.height.equalTo(@56);
        if(!_knowButton){
            make.bottom.equalTo(bgView.mas_bottom).offset(-40);
        }
    }];
    if(self.type == IntegralsPayFailuret_notVolunteer){
        [_knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
            make.top.equalTo(_button.mas_bottom).offset(16);
            make.left.equalTo(bgView.mas_left).offset(24);
            make.right.equalTo(bgView.mas_right).offset(-24);
            make.height.equalTo(@56);
            make.bottom.equalTo(bgView.mas_bottom).offset(-40);
            
        }];
    }
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.mas_right).offset(-24);
    }];
    
    
}

- (void)show{
    if(self.animating) return;
    self.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        //        [self layoutIfNeeded];
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)hiddenAlert{
    [self hiddenAlertWithAnimated:YES];
    
}
- (void)hiddenAlertWithAnimated:(BOOL)animated{
    [self endEditing:YES];
    if(animated){
        if(self.animating) return;
        self.animating = YES;
        [UIView animateWithDuration:0.3 animations:^{
            //        self.transform = CGAffineTransformScale(self.transform, .5, .5);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.animating = NO;
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
    
}

- (NSString *)buttonName{
    NSString *title;
    switch (self.type) {
        case IntegralsPayFailuret_less:
            title = @"确  定";
            break;
        case IntegralsPayFailuret_notVolunteer:
            title = @"立即注册";
            break;
            
        default:
            break;
    }
    return title;
}

#pragma mark - lazyload
- (UIImageView *)suggestImageView{
    if(!_suggestImageView){
        _suggestImageView = [UIImageView new];
        _suggestImageView.image = [UIImage imageNamed:@"ps_failure_war"];
        _suggestImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _suggestImageView;
}
- (UILabel *)suggestLabel{
    if(!_suggestLabel){
        _suggestLabel = [UILabel new];
        _suggestLabel.numberOfLines = 0;
        _suggestLabel.textAlignment = NSTextAlignmentCenter;
        _suggestLabel.font = [UIFont systemFontOfSize:MScale * 17];
        _suggestLabel.textColor = MRGBColor(71, 86, 105);
    }
    return _suggestLabel;
}
- (MHThemeButton *)button{
    if(!_button){
        _button = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundColor:MRGBColor(229, 233, 242)];
        [_button setTitle:[self buttonName] forState:UIControlStateNormal];
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hiddenAlertWithAnimated:NO];
            if(self.compleBlock){
                self.compleBlock(0);
            }
        }];
        
    }
    return _button;
}
- (UIButton *)knowButton{
    if(!_knowButton){
        _knowButton = [UIButton new];
        _knowButton.layer.borderWidth = 1;
        _knowButton.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
        _knowButton.layer.cornerRadius = 3;
        _knowButton.layer.masksToBounds = YES;
        [_knowButton setTitleColor:MRGBColor(71, 86, 105) forState:UIControlStateNormal];
        [_knowButton setTitle:@"我知道了" forState:UIControlStateNormal];
        @weakify(self);
        [[_knowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hiddenAlertWithAnimated:NO];
            if(self.compleBlock){
                self.compleBlock(1);
            }
        }];
        
    }
    return _knowButton;
}

@end
