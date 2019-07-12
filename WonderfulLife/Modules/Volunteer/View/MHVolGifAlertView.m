//
//  MHVolGifAlertView.m
//  WonderfulLife
//
//  Created by Beelin on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolGifAlertView.h"
#import "MHThemeButton.h"
#import "MHMacros.h"
#import "YYText.h"
#import <UIImage+GIF.h>

@interface MHVolGifAlertView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *gifImv;
@property (weak, nonatomic) IBOutlet MHThemeButton *shootBtn;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation MHVolGifAlertView
+ (instancetype)volGifAlertView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVolGifAlertView" owner:nil options:0] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.gifImv.layer.borderColor = MColorSeparator.CGColor;
    self.gifImv.layer.borderWidth = 0.5;

    self.gifImv.image = [UIImage sd_animatedGIFNamed:@"exchange_type"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    attStr.yy_kern = @1;
    self.detailLabel.attributedText = attStr;
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setSimplyFlag:(BOOL)simplyFlag {
    if (simplyFlag) {
        self.titleLab.text = @"志愿者简约版模式已开启";
    } else {
        self.titleLab.text = @"志愿者标准版模式已开启";
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.titleLab.text];
    attStr.yy_kern = @1;
    self.titleLab.attributedText = attStr;
}

- (void)dismissSelf {
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = WINDOW.bounds;
}

- (IBAction)shootAction:(MHThemeButton *)sender {
     !self.shootBlock ?: self.shootBlock();
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.boxView]) {
        return NO;
    }
    return YES;
}
@end
