//
//  MHVoSeReviewButtonView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeReviewButtonView.h"

#import "UIView+MHFrame.h"
@interface MHVoSeReviewButtonView ()
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewedBtn;
@property (weak, nonatomic) IBOutlet UIView *redLine;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation MHVoSeReviewButtonView

+ (instancetype)voSeReviewButtonView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MHVoSeReviewButtonView" owner:self options:nil] lastObject];
}

- (IBAction)reviewAction:(UIButton *)sender {
    if (self.selectBtn == sender) {
        return;
    }
    
    self.selectBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        self.redLine.mh_x = sender.mh_x;
    }];
    self.reviewedBtn.selected = NO;
    sender.selected = YES;
    !self.clickReviewBlock ?: self.clickReviewBlock();
}

- (IBAction)reviewedAction:(UIButton *)sender {
    if (self.selectBtn == sender) {
        return;
    }
    
    self.selectBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        self.redLine.mh_x = sender.mh_x;
    }];
    self.reviewBtn.selected = NO;
    sender.selected = YES;
    !self.clickReviewedBlock ?: self.clickReviewedBlock();
    
}

- (void)clickReviewedButton {
    [self reviewedAction:self.reviewedBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
