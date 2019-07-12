//
//  MHMerchantOrderDetailStatusNormalCell.m
//  WonderfulLife
//
//  Created by zz on 26/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailStatusNormalCell.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailStatusNormalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOrderNumber;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end

@implementation MHMerchantOrderDetailStatusNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.gradientImageView.image = [UIImage mh_gradientImageWithBounds:self.gradientImageView.bounds direction:UIImageGradientDirectionRight colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];

}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    self.goodsOrderStatusLabel.text = model.order_status;
    self.goodsOrderNumber.text = model.order_no;
    
    [self updateStatusImage:model.order_status_type];
}

/*
 merchant_detail_finished
 merchant_detail_refunding
 merchant_detail_unpaid
 merchant_detail_unreviews
 merchant_detail_unused
 merchant_detail_warning
 
 订单状态枚举值，0待付款，1待使用，2待评价，3已评价,4退款中，5退款成功，6退款失败，7已过期
 
 */
- (void)updateStatusImage:(NSString *)status {
    NSString *imageName = @"merchant_detail_finished";
    NSInteger order_type = [status integerValue];
    if (order_type == 0) {
        imageName = @"merchant_detail_unpaid";
    }else if (order_type == 1) {
        imageName = @"merchant_detail_unused";
    }else if (order_type == 2) {
        imageName = @"merchant_detail_unreviews";
    }else if (order_type == 4) {
        imageName = @"merchant_detail_refunding";
    }else if (order_type == 7) {
        imageName = @"merchant_detail_warning";
    }
    _statusImage.image = [UIImage imageNamed:imageName];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
