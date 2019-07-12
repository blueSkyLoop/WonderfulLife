//
//  MHMineMerWithDrawView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithDrawView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@interface MHMineMerWithDrawView()

@property (nonatomic,strong)NSNumberFormatter *formatter;

@end

@implementation MHMineMerWithDrawView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    self.totalScoreLabel.font = MHSFont(56);
    self.balanceLabel.font = MHSFont(14);
    self.withDrawModelLabel.font = MHSFont(14);
    self.withDrawBtn.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.withDrawBtn.layer.borderWidth = 1;
    self.withDrawBtn.layer.cornerRadius = 6;
    self.withDrawBtn.layer.masksToBounds = YES;
    
    self.applyBtn.hidden = YES;
    self.applyBtn.subLayer.opacity = 0;
    self.withDrawBtn.hidden = NO;
    
    self.blaceCetenY.constant = -(MScreenW / 4.0);
    self.modelCentenY.constant = MScreenW / 4.0;
    
    //初始化置空，避免看到假数据
    self.withDrawModelLabel.text = @" ";
    self.balanceLabel.text = @" ";
    self.applyBtn.enabled = NO;
    self.withDrawBtn.enabled = NO;
}

- (void)configDataWithModel:(MHMinMerWithdrawMainModel *)model{
    NSString *totalScore = [self.formatter stringFromNumber:@(model.amount_withdraw.doubleValue)];
    NSString *balance = [self.formatter stringFromNumber:@(model.amount_balance.doubleValue)];
    self.totalScoreLabel.text = totalScore;
    self.balanceLabel.text = balance;
    self.withDrawModelLabel.text = model.withdraw_mode;
    NSString *bankAccountStr = model.bank_card;
    if(bankAccountStr && bankAccountStr.length > 4){
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:nil];
        bankAccountStr = [regularExpression stringByReplacingMatchesInString:bankAccountStr options:0 range:NSMakeRange(0, bankAccountStr.length - 4) withTemplate:@"*"];
    }
    self.bankNameLabel.text = (model.bank_name && model.bank_name.length)?model.bank_name:@"未指定";
    self.bankAccountLabel.text = (bankAccountStr && bankAccountStr.length)?bankAccountStr:@"未指定";
    self.bankUserLabel.text = (model.account_name && model.account_name.length)?model.account_name:@"未指定";
    [self.withDrawBtn setTitle:model.withdraw_btn_name forState:UIControlStateNormal];
    [self.applyBtn setTitle:model.withdraw_btn_name forState:UIControlStateNormal];
    self.applyBtn.enabled = YES;
    self.withDrawBtn.enabled = YES;
    if(model.withdraw_mode_value == 0){
        if(model.is_manual_withdrawable){
            self.applyBtn.hidden = NO;
            self.withDrawBtn.hidden = YES;
//             self.applyBtn.enabled = model.is_manual_withdrawable?YES:NO;
        }else{
            self.applyBtn.hidden = YES;
            self.withDrawBtn.hidden = NO;
        }
       
    }else{
        self.applyBtn.hidden = YES;
        self.withDrawBtn.hidden = NO;
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
