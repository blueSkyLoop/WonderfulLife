//
//  MHMerchantOrderDetailStatusRefundingCell.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStatusRefundingCell.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailStatusRefundingCell()
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsPurchasingDate;

@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem1;
@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end

@implementation MHMerchantOrderDetailStatusRefundingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gradientImageView.image = [UIImage mh_gradientImageWithBounds:self.gradientImageView.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];

}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsPurchasingDate.text = model.refund_apply_time;
    self.goodsOrderNumber.text = model.order_no;
    self.goodsRefundItem1.text = model.refund_reason?:@" ";
    self.goodsRefundItem2.text = model.refund_remark?:@" ";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
