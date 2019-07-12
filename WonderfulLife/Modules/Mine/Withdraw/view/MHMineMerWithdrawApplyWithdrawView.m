//
//  MHMineMerWithdrawApplyWithdrawView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawApplyWithdrawView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@interface MHMineMerWithdrawApplyWithdrawView()

@property (nonatomic,strong)NSNumberFormatter *formatter;

@end

@implementation MHMineMerWithdrawApplyWithdrawView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    self.totalScoreLabel.font = MHSFont(56);
}

- (void)configDataWithModel:(MHMinMerWithdrawMainModel *)model{
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *totalScore = [self.formatter stringFromNumber:@(model.amount_withdraw.doubleValue)];
    self.totalScoreLabel.text = totalScore;
    NSString *blance = [self.formatter stringFromNumber:@(model.amount_withdraw.doubleValue)];
    self.balanceLabel.text = blance?:@" ";
    self.bankNameLabel.text = (model.bank_name && model.bank_name.length)?model.bank_name:@"未指定";
    NSString *bankAccountStr = model.bank_card;
    if(bankAccountStr && bankAccountStr.length > 4){
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:nil];
        bankAccountStr = [regularExpression stringByReplacingMatchesInString:bankAccountStr options:0 range:NSMakeRange(0, bankAccountStr.length - 4) withTemplate:@"*"];
    }
    self.bankAccountLabel.text = (bankAccountStr && bankAccountStr.length)?bankAccountStr:@"未指定";
    self.bankUserLabel.text = (model.account_name && model.account_name.length)?model.account_name:@"未指定";
    //手动模式下
    if(model.withdraw_mode_value == 0){
        //不能提现
        if(model.is_manual_withdrawable == 0){
            self.applyBtn.enabled = NO;
        }else if(model.is_manual_withdrawable == 1){//可提现
            self.applyBtn.enabled = YES;
        }
        
    }else{
        self.applyBtn.enabled = NO;
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
