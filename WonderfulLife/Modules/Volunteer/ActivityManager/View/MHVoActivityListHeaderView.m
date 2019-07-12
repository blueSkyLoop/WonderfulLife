//
//  MHVoActivityListHeaderView.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVoActivityListHeaderView.h"
#import "UIView+NIM.h"
#import "MHMacros.h"

@interface MHVoActivityListHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *indexLine;
@property (strong,nonatomic) UIButton *selectedBtn;
@end

@implementation MHVoActivityListHeaderView

+ (instancetype)voSeButtonHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVoActivityListHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.selected = YES;
    self.leftBtn.enabled = NO;
    self.selectedBtn = self.leftBtn;
    
    self.layer.cornerRadius = 6;
    self.layer.borderColor = MColorSeparator.CGColor;
    self.layer.borderWidth = 0.5;
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 5;
    self.layer.shadowColor = MColorShadow.CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indexLine.nim_centerX = self.selectedBtn.nim_centerX;
}

- (IBAction)clickAction:(UIButton *)sender {
    if (sender == self.leftBtn) {
        self.rightBtn.selected = NO;
        self.rightBtn.enabled = YES;
    } else {
        self.leftBtn.selected = NO;
        self.leftBtn.enabled = YES;
    }
    
    sender.selected = YES;
    self.selectedBtn = sender;
    self.selectedBtn.enabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.indexLine.nim_centerX = sender.nim_centerX;
    }];
    !self.clickBlock ?: self.clickBlock(sender.tag);
}

- (void)changeToDoingStatus {
    self.rightBtn.selected = NO;
    self.leftBtn.selected = YES;
    self.rightBtn.enabled = YES;
    self.selectedBtn = self.leftBtn;
    self.selectedBtn.enabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.indexLine.nim_centerX = self.leftBtn.nim_centerX;
    }];
}

@end
