//
//  LIntegralsComplePayView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LIntegralsComplePayView.h"
#import "LCommonModel.h"

@implementation LIntegralsComplePayView

+ (LIntegralsComplePayView *)loadViewFromXib{
    LIntegralsComplePayView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
}

- (void)configWithInfor:(LIntegralsGoodsModel *)model{
    self.integralsNumLabel.text = [NSString stringWithFormat:@"%@%@",model.score_need_pay?:@"",@"积分"];
    self.commodityLabel.text = model.goods_name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",model.qty];
    self.cashierLabel.text = model.payee;
}
- (IBAction)compleAction:(MHThemeButton *)sender {
    [self.payCompleSubject sendNext:nil];
}

- (RACSubject *)payCompleSubject{
    if(!_payCompleSubject){
        _payCompleSubject = [RACSubject subject];
    }
    return _payCompleSubject;
}

@end
