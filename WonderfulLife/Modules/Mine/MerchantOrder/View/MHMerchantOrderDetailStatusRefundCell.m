//
//  MHMerchantOrderDetailStatusCell.m
//  WonderfulLife
//
//  Created by zz on 26/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStatusRefundCell.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "MHMerchantOrderDetailModel.h"

static NSString *const goodsOrderStatus1 = @"已退款";
static NSString *const goodsItem1Title1 = @"退款理由";
static NSString *const goodsItem2Title1 = @"退款说明";

static NSString *const goodsOrderStatus2 = @"退款失败，待使用";
static NSString *const goodsItem1Title2 = @"退款日期";
static NSString *const goodsItem2Title2 = @"拒绝理由";

static NSString *const goodsOrderStatus3 = @"退款中";


@interface MHMerchantOrderDetailStatusRefundCell ()
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsPurchasingDate;
@property (weak, nonatomic) IBOutlet UILabel *goodsOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *goodsOwnerPhone;

@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem1;
@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem2;

@end

@implementation MHMerchantOrderDetailStatusRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gradientImageView.image = [UIImage mh_gradientImageWithBounds:self.gradientImageView.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel *)model {
    self.goodsOrderNumber.text = model.order_no;
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsOwnerName.text = model.nickname;
    self.goodsOwnerPhone.text = model.login_username;
    self.goodsPurchasingDate.text = model.refund_apply_time;
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsRefundItem1.text = model.refund_reason?:@" ";
    self.goodsRefundItem2.text = model.refund_remark?:@" ";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
