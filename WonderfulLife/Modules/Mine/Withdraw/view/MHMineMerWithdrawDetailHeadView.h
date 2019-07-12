//
//  MHMineMerWithdrawDetailHeadView.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseView.h"
#import "MHMineMerWithdrawDetailModel.h"

@interface MHMineMerWithdrawDetailHeadView : MHBaseView

@property (nonatomic,weak) IBOutlet UILabel *totalScoreLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *amountLabel;
@property (nonatomic,weak) IBOutlet UILabel *applyTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *withdrawNoLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

- (void)configWithData:(MHMineMerWithdrawDetailModel *)model;

@end
