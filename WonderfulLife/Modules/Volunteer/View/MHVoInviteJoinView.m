//
//  MHVoInviteJoinView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoInviteJoinView.h"

#import "MHMacros.h"
#import "UIImage+Color.h"
#import "UIView+MHFrame.h"

#import "NSObject+isNull.h"

#import <Masonry.h>
@interface MHVoInviteJoinView ()
@property (nonatomic, strong) UIImageView *backgrandImv;
@property (nonatomic, strong) UILabel *numbelLab;
@property (nonatomic, strong) UIButton *inviteBtn;
@property (nonatomic, strong) UILabel *introlLab;
@property (nonatomic, strong) UIImageView *swipeUpImv;
@property (nonatomic, strong) UISwipeGestureRecognizer *panGes;
@property (nonatomic, strong) UIView *panView;
@end

@implementation MHVoInviteJoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addControls];
        [self layoutControls];
    }
    return self;
}

- (void)addControls {
    [self addSubview:self.backgrandImv];
    [self addSubview:self.numbelLab];
    [self addSubview:self.inviteBtn];
    [self addSubview:self.introlLab];
    [self addSubview:self.swipeUpImv];
    
    [self addGestureRecognizer:self.panGes];
    
    
}

- (void)layoutControls {
    self.backgrandImv.frame = self.bounds;
    [self.numbelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset((440 *(self.mh_h /MScreenH)) * (MScreenH / 667.0));
        make.height.mas_equalTo(14);
    }];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numbelLab.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self);
    }];
    [self.introlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteBtn.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    [self.swipeUpImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introlLab.mas_bottom).mas_offset(8);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(26.5);
        make.height.mas_equalTo(16.5);
    }];
//    [self.panView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.introlLab);
//        make.left.equalTo(self.introlLab);
//        make.right.equalTo(self.introlLab);
//        make.bottom.equalTo(self.swipeUpImv.mas_bottom);
//    }];
    
  
}
#pragma mark - Event
- (void)inviteAction {
    !self.clickInviteBlock ?: self.clickInviteBlock();
}

- (void)dismissSelf {
    [UIView animateWithDuration:1 animations:^{
        CGRect f = self.frame;
        f.origin.y -= f.size.height;
        self.frame = f;
    } completion:^(BOOL finished) {
        !self.clickPanUpBlock ?: self.clickPanUpBlock();
    }];
}

#pragma mark - Public
- (void)showSelf {
    [UIView animateWithDuration:1 animations:^{
        CGRect f = self.frame;
        f.origin.y = 0;
        self.frame = f;
    } completion:^(BOOL finished) {
    }];
 
}

#pragma mark - Setter
- (void)setHeadcount:(NSString *)headcount {
    _headcount = headcount;
    self.numbelLab.text = [NSString stringWithFormat:@"%@位志愿者在等着您", _headcount];
    self.numbelLab.hidden = [NSObject isNull:headcount];
}
#pragma mark - Getter

- (UIImageView *)backgrandImv {
    if (!_backgrandImv) {
        _backgrandImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_intivePage"]];
    }
    return _backgrandImv;
}

- (UILabel *)numbelLab {
    if (!_numbelLab) {
        _numbelLab = [[UILabel alloc] init];
        _numbelLab.textColor = [UIColor whiteColor];
        _numbelLab.font = [UIFont systemFontOfSize:14];
    }
    return _numbelLab;
}

- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.frame = CGRectMake(0, 0, 267, 70);
        [_inviteBtn setBackgroundImage:[UIImage mh_gradientImageWithBounds:_inviteBtn.bounds direction:UIImageGradientDirectionDown colors:@[MColorToRGB(0XF8FA61), MColorToRGB(0XF7D51C)]] forState:UIControlStateNormal];
        [_inviteBtn setBackgroundImage:[UIImage mh_gradientImageWithBounds:_inviteBtn.bounds direction:UIImageGradientDirectionDown colors:@[MColorToRGB(0XF8FA61), MColorToRGB(0XF7D51C)]] forState:UIControlStateHighlighted];
        [_inviteBtn setTitleColor:MColorRed forState:UIControlStateNormal];
        [_inviteBtn setTitle:@"加入我们" forState:UIControlStateNormal];
        _inviteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _inviteBtn.layer.masksToBounds = YES;
        _inviteBtn.layer.cornerRadius = 35;
        [_inviteBtn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}

- (UILabel *)introlLab {
    if (!_introlLab) {
        _introlLab = [[UILabel alloc] init];
        _introlLab.text = @"滑动查看志愿者介绍";
        _introlLab.textColor = [UIColor whiteColor];
        _introlLab.font = MFont(15);
        _introlLab.userInteractionEnabled = YES;
         }
    return _introlLab;
}

- (UIImageView *)swipeUpImv {
    if (!_swipeUpImv) {
        _swipeUpImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_downArrow"]];
        _swipeUpImv.userInteractionEnabled = YES;
        
        CABasicAnimation *ani = [CABasicAnimation animation];
        ani.keyPath = @"position.y";
        ani.byValue = @10;
        ani.repeatCount = MAXFLOAT;
        ani.duration = 0.5;
        ani.fillMode = kCAFillModeForwards;
        ani.autoreverses = YES;
        ani.removedOnCompletion = NO;
        [_swipeUpImv.layer addAnimation:ani forKey:nil];
    }
    return _swipeUpImv;
}

- (UISwipeGestureRecognizer *)panGes {
    if (!_panGes) {
        _panGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        _panGes.direction = UISwipeGestureRecognizerDirectionUp;
            }
    return _panGes;
}

- (UIView *)panView {
    if (!_panView) {
        _panView = [UIView new];
        _panView.userInteractionEnabled = YES;
    }
    return _panView;
}
@end
