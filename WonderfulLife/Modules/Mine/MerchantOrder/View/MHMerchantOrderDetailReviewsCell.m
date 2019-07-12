//
//  MHMerchantOrderDetailReviewsCell.m
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailReviewsCell.h"
#import "MHMerchantOrderDetailModel.h"
#import "MHMacros.h"

static NSString *const defaultReviewsString = @"超时未评价，系统默认好评";

@interface MHMerchantOrderDetailReviewsCell ()
/**历史销量*/
@property (weak, nonatomic) IBOutlet UILabel *historyVolumeLabel;//历史销量
/**订单总额*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**实际支付*/
@property (weak, nonatomic) IBOutlet UILabel *actualPaidLabel;
/**积分抵扣*/
@property (weak, nonatomic) IBOutlet UILabel *scorePaidLabel;
/**支付类型*/
@property (weak, nonatomic) IBOutlet UILabel *paidTypeLabel;
/**有效期*/
@property (weak, nonatomic) IBOutlet UILabel *goodsPurchasingDateLabel;
/**下单时间*/
@property (weak, nonatomic) IBOutlet UILabel *takeOrderDateLabel;
/**商品评论*/
@property (weak, nonatomic) IBOutlet UILabel *goodsCommentLabel;
/**商家评价*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton*> *merchantStarsLevel;
/**商品评价*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton*> *goodsStarsLevel;
@end

@implementation MHMerchantOrderDetailReviewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {

    self.historyVolumeLabel.text = model.coupon_sales?:[model.sales stringValue];
    self.paidTypeLabel.text = model.payment_mode;
    self.goodsCommentLabel.text = model.comment?:@" ";
    self.priceLabel.text = model.pay_amount?@"¥".format(model.pay_amount):@"¥".format(model.order_price);
    self.takeOrderDateLabel.text = model.order_time?:model.create_datetime;
    if (model.expiry_time_begin.length != 0 && model.expiry_time_end.length != 0) {
        self.goodsPurchasingDateLabel.text = model.expiry_time_begin.format(@"至").format(model.expiry_time_end);
    }else if (model.expiry_time) {
        self.goodsPurchasingDateLabel.text = model.expiry_time;
    }

    //2018.1.8 新增需求
    self.actualPaidLabel.text = model.actual_pay_amount?@"¥".format(model.actual_pay_amount):@"¥0.00";
    self.scorePaidLabel.text = model.pay_score?@"¥".format(model.pay_score):@"¥0.00";
    
    //重置文本颜色...
    self.goodsCommentLabel.textColor = self.takeOrderDateLabel.textColor;
    if (!model.comment&&!model.grade_to_merchant&&!model.grade_to_goods&&[model.goods_type isEqualToNumber:@0]) {
        self.goodsCommentLabel.text = defaultReviewsString;
      //  self.goodsCommentLabel.textColor = MColorRed;
    }
    
    [self showMerchantStarsLevel:model.grade_to_merchant];
    [self showGoodsStarsLevel:model.grade_to_goods];
}


- (void)showMerchantStarsLevel:(NSNumber*)levels {
    __block NSUInteger level = [levels integerValue];
    [_merchantStarsLevel enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < level) {
            obj.selected = YES;
        }else {
            obj.selected = NO;
        }
    }];
    
}

- (void)showGoodsStarsLevel:(NSNumber*)levels {
    __block NSUInteger level = [levels integerValue];
    [_goodsStarsLevel enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < level) {
            obj.selected = YES;
        }else {
            obj.selected = NO;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
