//
//  MHMineMerWithdrawDetailHeadView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawDetailHeadView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@interface MHMineMerWithdrawDetailHeadView()

@property (nonatomic,strong)NSNumberFormatter *formatter;

@end

@implementation MHMineMerWithdrawDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    self.totalScoreLabel.font = MHSFont(48);
    self.statusLabel.font = MHSFont(18);
    
}

- (void)configWithData:(MHMineMerWithdrawDetailModel *)model{
  
    self.totalScoreLabel.text = [self.formatter stringFromNumber:@(model.amount_apply.doubleValue)];
    self.statusLabel.text = model.withdraw_status;
    self.amountLabel.text = [self.formatter stringFromNumber:@(model.amount_apply.doubleValue)];
    self.applyTimeLabel.text = model.apply_time;
    self.withdrawNoLabel.text = model.withdraw_no;
    self.timeLabel.text = model.period;
    if(model.withdraw_status_value == 0){//申请中
        self.statusLabel.textColor = MRGBColor(32, 160, 255);
    }else if(model.withdraw_status_value == 1){//提现成功
        self.statusLabel.textColor = MRGBColor(19, 206, 102);
    }
}

- (NSNumberFormatter *)formatter{
    if(!_formatter){
        _formatter = [[NSNumberFormatter alloc] init];
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _formatter.maximumFractionDigits = 2;
        _formatter.minimumFractionDigits = 2;
    }
    return _formatter;
}

@end
