//
//  MHMineMerWithdrawRecordCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawRecordCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"

#import "MHMineMerWithdrawRecordModel.h"

@interface MHMineMerWithdrawRecordCell()

@property (nonatomic,strong)NSNumberFormatter *formatter;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlePidLabel;

@end

@implementation MHMineMerWithdrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self.contentView];
    self.applyStatusLabel.font = MHSFont(18);
    self.appleAmountLabel.font = MHSFont(18);
    
    
    self.timeLabel.preferredMaxLayoutWidth = MScreenW - 24 * 2 - 8 - [self.titleTimeLabel sizeThatFits:CGSizeMake(MScreenW, 30)].width;
    self.withdrawNoLabel.preferredMaxLayoutWidth = MScreenW - 24 * 2 - 8 - [self.titleNoLabel sizeThatFits:CGSizeMake(MScreenW, 30)].width;
    self.dateLabel.preferredMaxLayoutWidth = MScreenW - 24 * 2 - 8 - [self.titlePidLabel sizeThatFits:CGSizeMake(MScreenW, 30)].width;
}

- (void)mh_configCellWithInfor:(MHMineMerWithdrawRecordModel *)model{
    NSString *applyAmount = [self.formatter stringFromNumber:@(model.amount_apply.doubleValue)];
    self.appleAmountLabel.text = applyAmount;
    self.applyStatusLabel.text = model.withdraw_status;
    self.timeLabel.text = model.apply_time?:@" ";
    self.withdrawNoLabel.text = model.withdraw_no?:@" ";
    self.dateLabel.text = model.period?:@" ";
    if(model.withdraw_status_value == 0){//申请中
        self.applyStatusLabel.textColor = MRGBColor(32, 160, 255);
    }else if(model.withdraw_status_value == 1){//提现成功
        self.applyStatusLabel.textColor = MRGBColor(19, 206, 102);
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
