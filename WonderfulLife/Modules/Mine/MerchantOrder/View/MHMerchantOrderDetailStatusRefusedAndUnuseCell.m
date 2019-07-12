//
//  MHMerchantOrderDetailStatusRefusedAndUnuseCell.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStatusRefusedAndUnuseCell.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailStatusRefusedAndUnuseCell()
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsApplyForRefundDate;
@property (weak, nonatomic) IBOutlet UILabel *goodsRefundedDate;
@property (weak, nonatomic) IBOutlet UILabel *acceptOrRefuseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *refuseReasonTitle;

@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem1;
@property (weak, nonatomic) IBOutlet UILabel *goodsRefundItem2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end

@implementation MHMerchantOrderDetailStatusRefusedAndUnuseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gradientImageView.image = [UIImage mh_gradientImageWithBounds:self.gradientImageView.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];

}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    self.goodsOrderNumber.text = model.order_no;
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsRefundedDate.text = model.refund_apply_time;
    self.goodsApplyForRefundDate.text = model.refund_apply_time;
    self.goodsRefundItem2.text = model.refund_remark?:@" ";
    
    if ([model.order_status_type isEqualToString:@"5"]) {
        self.refuseReasonTitle.text = @"退款理由：";
        self.goodsRefundItem1.text = model.refund_reason?:@" ";
        self.statusImage.image = [UIImage imageNamed:@"merchant_detail_finished"];
    }else if ([model.order_status_type isEqualToString:@"6"]) {
        self.refuseReasonTitle.text = @"拒绝理由：";
        self.goodsRefundItem1.text = model.refund_audit_remark?:@" ";
        self.statusImage.image = [UIImage imageNamed:@"merchant_detail_unused"];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
