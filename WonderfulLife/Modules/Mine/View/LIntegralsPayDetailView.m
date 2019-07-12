//
//  LIntegralsPayDetailView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LIntegralsPayDetailView.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@implementation LIntegralsPayDetailView

+ (LIntegralsPayDetailView *)loadViewFromXib{
    LIntegralsPayDetailView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.integralsBgView.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.integralsBgView.layer.borderWidth = 1.0;
    self.integralsBgView.layer.cornerRadius = 3;
    self.integralsBgView.layer.masksToBounds = YES;
    
    [LCommonModel resetFontSizeWithView:self];
}

- (void)configWithInfor:(LIntegralsGoodsModel *)model{
    self.integralsNumLabel.text = model.score_need_pay;
    self.commodityLabel.text = model.goods_name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",model.qty];
    self.cashierLabel.text = model.payee;
    self.orderNumLabel.text = model.order_no;
}

- (IBAction)payAction:(MHThemeButton *)sender {
    [self.paySubject sendNext:nil];
}

- (RACSubject *)paySubject{
    if(!_paySubject){
        _paySubject = [RACSubject subject];
    }
    return _paySubject;
}
@end
