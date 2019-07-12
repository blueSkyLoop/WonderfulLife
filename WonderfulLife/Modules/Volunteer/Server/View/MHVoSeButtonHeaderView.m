//
//  MHVoSeButtonHeaderView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeButtonHeaderView.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"

@interface MHVoSeButtonHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *indexLine;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *monBtn;

@end

@implementation MHVoSeButtonHeaderView

+ (instancetype)voSeButtonHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVoSeButtonHeaderView" owner:nil options:nil] lastObject];
}
- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 64, MScreenW, 88);
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.dayBtn.selected = YES;
    
    
}
- (IBAction)clickAction:(UIButton *)sender {
    if (sender == self.dayBtn) {
        self.monBtn.selected = NO;
    } else {
        self.dayBtn.selected = NO;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.indexLine.mh_x = sender.mh_x;
    }];
    !self.clickBlock ?: self.clickBlock(sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
