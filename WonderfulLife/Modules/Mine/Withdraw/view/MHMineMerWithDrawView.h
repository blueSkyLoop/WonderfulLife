//
//  MHMineMerWithDrawView.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseView.h"
#import "MHThemeButton.h"
#import "MHMinMerWithdrawMainModel.h"

@interface MHMineMerWithDrawView : MHBaseView
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *withDrawModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet MHThemeButton *applyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blaceCetenY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modelCentenY;

- (void)configDataWithModel:(MHMinMerWithdrawMainModel *)model;

@end
