//
//  MHMerchantOrderDetailStatusRefusedCell.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStatusRefusedCell.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailStatusRefusedCell()
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsOrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsPurchasingDate;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *refuseReason;
@property (weak, nonatomic) IBOutlet UILabel *refundReason;
@property (weak, nonatomic) IBOutlet UILabel *refundRemark;


@end

@implementation MHMerchantOrderDetailStatusRefusedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gradientImageView.image = [UIImage mh_gradientImageWithBounds:self.gradientImageView.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsOrderNumber.text = model.order_no;
    self.goodsPurchasingDate.text = model.refund_apply_time;
    self.userName.text = model.nickname;
    self.userPhone.text = model.login_username;
    self.refuseReason.text = model.refund_audit_remark?:@" ";
    self.refundReason.text = model.refund_reason?:@" ";
    self.refundRemark.text = model.refund_remark?:@" ";
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
