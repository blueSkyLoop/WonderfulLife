//
//  MHMineMerWithdrawApplyWithdrawView.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"
#import "MHThemeButton.h"
#import "MHMinMerWithdrawMainModel.h"

@interface MHMineMerWithdrawApplyWithdrawView : MHBaseView

@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankUserLabel;
@property (weak, nonatomic) IBOutlet MHThemeButton *applyBtn;

- (void)configDataWithModel:(MHMinMerWithdrawMainModel *)model;

@end
