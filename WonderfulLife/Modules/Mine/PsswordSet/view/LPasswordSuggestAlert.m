//
//  LPasswordSuggestAlert.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordSuggestAlert.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

@interface LPasswordSuggestAlert()

@property (nonatomic,copy)void(^compleBlock)(void);
@property (nonatomic,assign)BOOL animating;

@end

@implementation LPasswordSuggestAlert

- (id)initWithSuggestComple:(void(^)(void))comple{
    self = [super init];
    if(self){
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
        make.bottom.equalTo(bgView.mas_bottom).offset(-40);
    }];
    
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
    if(self.animating) return;
    self.animating = YES;
    [UIView animateWithDuration:0.3 animations:^{
//        self.transform = CGAffineTransformScale(self.transform, .5, .5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
    
}

#pragma mark - lazyload
- (UIImageView *)suggestImageView{
    if(!_suggestImageView){
        _suggestImageView = [UIImageView new];
        _suggestImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _suggestImageView;
}
- (UILabel *)suggestLabel{
    if(!_suggestLabel){
        _suggestLabel = [UILabel new];
        _suggestLabel.font = [UIFont systemFontOfSize:MScale * 32];
        _suggestLabel.textColor = MRGBColor(71, 86, 105);
    }
    return _suggestLabel;
}
- (MHThemeButton *)button{
    if(!_button){
        _button = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundColor:MRGBColor(229, 233, 242)];
        _button.titleLabel.font = [UIFont systemFontOfSize:MScale * 19];
        [_button setTitle:@"确  定" forState:UIControlStateNormal];
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hiddenAlert];
            if(self.compleBlock){
                self.compleBlock();
            }
        }];

    }
    return _button;
}

@end
