//
//  MHVolExchangeAlertView.m
//  WonderfulLife
//
//  Created by Beelin on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolExchangeAlertView.h"
#import "MHThemeButton.h"
#import "MHMacros.h"
@interface MHVolExchangeAlertView ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIButton *stanBtn;
@property (weak, nonatomic) IBOutlet UIButton *simBtn;
@property (weak, nonatomic) IBOutlet MHThemeButton *shootBtn;

@property (nonatomic, strong) UIButton *selectBtnFlag;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation MHVolExchangeAlertView

+ (instancetype)volExchangeAlertView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVolExchangeAlertView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = obj.constant *(MScreenW/375.0);
    }];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.shootBtn.enabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = WINDOW.bounds;
}

- (void)dismissSelf {
    [self removeFromSuperview];
}

- (IBAction)selectType:(UIButton *)sender {
    self.imageView1.highlighted = sender.tag == 0;
    self.imageView2.highlighted = sender.tag == 1;
    self.selectBtnFlag = sender ;
    self.shootBtn.enabled = YES;
}

- (IBAction)shootAction:(UIButton *)sender {
    !self.shootBlock ?: self.shootBlock(self.selectBtnFlag.tag == 1 ? YES : NO);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.boxView]) {
        return NO;
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
