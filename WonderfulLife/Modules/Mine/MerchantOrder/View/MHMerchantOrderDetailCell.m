//
//  MHMerchantOrderDetailCell.m
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailCell.h"
#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailCell ()
/**历史销量*/
@property (weak, nonatomic) IBOutlet UILabel *historyVolumeLabel;
/**订单总额*/
@property (weak, nonatomic) IBOutlet UILabel *paidAccountLabel;
/**实际支付*/
@property (weak, nonatomic) IBOutlet UILabel *actualPaidLabel;
/**积分抵扣*/
@property (weak, nonatomic) IBOutlet UILabel *scorePaidLabel;
/**支付类型*/
@property (weak, nonatomic) IBOutlet UILabel *paidTypeLabel;
/**有效日期*/
@property (weak, nonatomic) IBOutlet UILabel *goodsPurchasingDateLabel;
/**下单时间*/
@property (weak, nonatomic) IBOutlet UILabel *takeOrderDateLabel;
@end

@implementation MHMerchantOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    
    self.historyVolumeLabel.text = model.coupon_sales?:[model.sales stringValue];
    self.paidTypeLabel.text = model.payment_mode?:@"未支付";
    self.goodsPurchasingDateLabel.text = model.expiry_time?:model.expiry_time_begin.format(@"至").format(model.expiry_time_end);
    self.takeOrderDateLabel.text = model.order_time?:model.create_datetime;
    self.paidAccountLabel.text = model.pay_amount?@"¥".format(model.pay_amount):@"¥".format(model.order_price);
    //2018.1.8 新增需求
    if (![model.order_status_type isEqualToString:@"0"]) {
        self.actualPaidLabel.text = model.actual_pay_amount?@"¥".format(model.actual_pay_amount):@"¥0.00";
        self.scorePaidLabel.text = model.pay_score?@"¥".format(model.pay_score):@"¥0.00";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
