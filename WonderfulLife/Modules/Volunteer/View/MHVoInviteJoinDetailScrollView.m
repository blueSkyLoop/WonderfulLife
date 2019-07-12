//
//  MHVoInviteJoinDetailScrollView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoInviteJoinDetailScrollView.h"

#import "MHMacros.h"
#import "UIImage+Color.h"
#import "MHConstSDKConfig.h"
#import "NSObject+isNull.h"
@interface MHVoInviteJoinDetailScrollView ()
@property (nonatomic, strong) UIImageView *bgimv;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UIButton *inBtn;

@end


@implementation MHVoInviteJoinDetailScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addControls];
        
        self.bounces = NO;
        [self setContentSize:CGSizeMake(MScreenW, self.bgimv.frame.size.height)];
    }
    return self;
}


- (void)addControls {
    [self addSubview:self.bgimv];
    
    NSInteger btnX = 20;
    NSInteger btnY = 3000/2.0;
    NSInteger btnW = MScreenW - 40;
    NSInteger btnH = 490/2.0;
    for (int i = 0; i < 4; i ++) {
        if (i != 0) btnY += btnH + 50/2.0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag = i;
        [btn addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgimv addSubview:btn];
    }
    
    self.inBtn.frame = CGRectMake(MScreenW / 2.0 - 267/2.0, MGetMaxYAddValue(self.bgimv, - 70 - 95), 267, 70);
    [self.bgimv addSubview:self.inBtn];
    
    
    self.numLab.frame = CGRectMake(0, MGetMinYAddValue(self.inBtn, - 34), MScreenW, 14);
    [self.bgimv addSubview:self.numLab];
}

#pragma mark - Event
- (void)goDetail:(UIButton *)sender {
    NSString *url = nil;
    switch (sender.tag) {
        case 0:
           url = [NSString stringWithFormat:@"%@h5/happyDining", baseUrl];
            break;
        case 1:
             url = [NSString stringWithFormat:@"%@h5/obligationHaircut", baseUrl];
            break;
        case 2:
            url = [NSString stringWithFormat:@"%@h5/fourHalfClass", baseUrl];
            break;
        case 3:
          url = [NSString stringWithFormat:@"%@h5/oldmanSchool", baseUrl];
            break;
    }
    
    if (!url) return;
    !self.goinDetailBlock ?: self.goinDetailBlock(url);
}

- (void)inviteAction {
    !self.clickInviteBlock ?: self.clickInviteBlock();
}

#pragma mark - Setter
- (void)setHeadcount:(NSString *)headcount {
    _headcount = headcount;
    self.numLab.text = [NSString stringWithFormat:@"%@位志愿者在等着您", _headcount];
    self.numLab.hidden = [NSObject isNull:headcount];
}

- (void)setHiddenJoinButton:(BOOL)hiddenJoinButton {
    _hiddenJoinButton = hiddenJoinButton;
    self.inBtn.hidden = _hiddenJoinButton;
    
}
#pragma mark - Getter
- (UIImageView *)bgimv {
    if (!_bgimv) {
        _bgimv = [[UIImageView alloc] init];
        _bgimv.image = [UIImage imageNamed:@"vo_intiveDetail"];
        _bgimv.frame = CGRectMake(0, 0, MScreenW, _bgimv.image.size.height);
        _bgimv.userInteractionEnabled = YES;
    }
    return _bgimv;
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.textColor = [UIColor whiteColor];
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.font = [UIFont systemFontOfSize:14];
    }
    return _numLab;
}

- (UIButton *)inBtn {
    if (!_inBtn) {
        _inBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inBtn.frame = CGRectMake(0, 0, 267, 70);
        [_inBtn setBackgroundImage:[UIImage mh_gradientImageWithBounds:_inBtn.bounds direction:UIImageGradientDirectionDown colors:@[MColorToRGB(0XF8FA61), MColorToRGB(0XF7D51C)]] forState:UIControlStateNormal];
        [_inBtn setBackgroundImage:[UIImage mh_gradientImageWithBounds:_inBtn.bounds direction:UIImageGradientDirectionDown colors:@[MColorToRGB(0XF8FA61), MColorToRGB(0XF7D51C)]] forState:UIControlStateHighlighted];
        [_inBtn setTitleColor:MColorRed forState:UIControlStateNormal];
        [_inBtn setTitle:@"加入我们" forState:UIControlStateNormal];
        _inBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _inBtn.layer.masksToBounds = YES;
        _inBtn.layer.cornerRadius = 35;
        [_inBtn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inBtn;
}

- (UIImageView *)swipeUpImv {
    if (!_swipeUpImv) {
        _swipeUpImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_downArrow"]];
        _swipeUpImv.transform = CGAffineTransformMakeRotation(M_PI);
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
@end
