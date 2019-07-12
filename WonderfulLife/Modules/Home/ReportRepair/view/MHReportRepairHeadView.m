//
//  MHReportRepairHeadView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairHeadView.h"
#import "Masonry.h"
#import "MHMacros.h"

@interface MHReportRepairHeadView()

@property (nonatomic,strong)UIButton *currentButton;

@end

@implementation MHReportRepairHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.buttonLeft.selected = YES;
    self.currentButton = self.buttonLeft;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@3);
        make.centerX.equalTo(self.currentButton.mas_centerX);
        make.width.equalTo(self.currentButton.mas_width).multipliedBy(1.2);
    }];
    
    self.gapLaoutTwo.constant = 49 * MScale;
    self.gapLayoutOne.constant = 49 * MScale;
    
    [self layoutIfNeeded];
    
}
- (IBAction)buttClikAction:(UIButton *)sender {
    if(sender == self.currentButton){
        return;
    }
    sender.selected = YES;
    self.currentButton.selected = NO;
    self.currentButton = sender;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@3);
        make.centerX.equalTo(self.currentButton.mas_centerX);
        make.width.equalTo(self.currentButton.mas_width).multipliedBy(1.2);
    }];
    
    [UIView animateWithDuration:.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    if(self.headItemClikBlock){
        self.headItemClikBlock(self.currentButton.tag - 1);
    }
}

- (void)makeSelectIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:index + 1];
    [self buttClikAction:button];
}

@end
