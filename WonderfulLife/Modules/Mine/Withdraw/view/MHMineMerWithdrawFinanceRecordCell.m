//
//  MHMineMerWithdrawFinanceRecordCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawFinanceRecordCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"

#import "MHMineMerWithdrawDetailModel.h"

@interface MHMineMerWithdrawFinanceRecordCell()

@property (nonatomic,strong)NSNumberFormatter *formatter;

@end

@implementation MHMineMerWithdrawFinanceRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self.contentView];
}

- (void)mh_configCellWithInfor:(MHMineMerWithdrawFinanceRecordModel *)model{
    
//    NSString *prefixStr ;
//    NSString *amount;
//    if(model.change_amount && model.change_amount.length){
//        NSString *astr = [model.change_amount substringToIndex:1];
//        if([astr isEqualToString:@"+"]){
//            prefixStr = astr;
//        }else if([astr isEqualToString:@"-"]){
//            prefixStr = astr;
//        }
//        amount = model.change_amount;
//        if(prefixStr){
//            amount = [amount stringByReplacingOccurrencesOfString:prefixStr withString:@""];
//        }
//        amount = [amount stringByReplacingOccurrencesOfString:@" " withString:@""];
//        amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
//        amount = [amount stringByReplacingOccurrencesOfString:@"，" withString:@""];
//        amount = [amount stringByReplacingOccurrencesOfString:@"积分" withString:@""];
//    }
//    amount = [NSString stringWithFormat:@"%@%@%@",prefixStr?:@"",amount?[self.formatter stringFromNumber:@(amount.doubleValue)]:@"0",@"积分"];
    
    self.scroreLabel.text = model.change_amount;
    self.timeLabel.text = model.change_time;
    self.nameLabel.text = model.change_type;
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
