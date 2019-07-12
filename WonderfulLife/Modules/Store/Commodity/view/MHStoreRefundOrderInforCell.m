//
//  MHStoreRefundOrderInforCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundOrderInforCell.h"
#import "LCommonModel.h"
#import "UIImage+Color.h"
#import "MHMacros.h"
#import "MHMerchantOrderDetailModel.h"
#import "MHMerchantOrderDelegate.h"

@implementation MHStoreRefundOrderInforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    self.colorBgView.image = [UIImage mh_imageGradientSetMainColorWithBounds:CGRectMake(0, 0, MScreenW, 100)];
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel *)model{
   
    self.statusLabel.text = model.order_status;
    self.orderNoLabel.text = model.order_no;
//    self.contentLabel.text = model.refund_content?:@" ";
    self.refundMethodLabel.text = model.refund_way?:@" ";
//    self.actualPayLabel.text = model.actual_pay_amount?:@" ";
//    self.intergralPayLabel.text = model.pay_score?:@" ";
    
    self.contentLabel.text = model.pay_amount?@"¥".format(model.pay_amount):@"¥".format(model.order_price);
    self.actualPayLabel.text = model.actual_pay_amount?@"¥".format(model.actual_pay_amount):@"¥0.00";
    self.intergralPayLabel.text = model.pay_score?@"¥".format(model.pay_score):@"¥0.00";
    
}

@end
