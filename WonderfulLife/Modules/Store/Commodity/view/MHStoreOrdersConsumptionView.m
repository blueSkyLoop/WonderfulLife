//
//  MHStoreOrdersConsumptionView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//
#import "LCommonModel.h"
#import "MHStoreOrdersConsumptionView.h"

@implementation MHStoreOrdersConsumptionView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    
}
- (IBAction)checkDetailAction:(UIButton *)sender {
    if(self.buttonClikBlock){
        self.buttonClikBlock(1);
    }
}
- (IBAction)cancelAction:(UIButton *)sender {
    if(self.buttonClikBlock){
        self.buttonClikBlock(2);
    }
}
- (IBAction)sureAction:(id)sender {
    if(self.buttonClikBlock){
        self.buttonClikBlock(3);
    }
}

- (void)configWithDict:(NSDictionary *)dict{
    /*
     order_no  string 订单号  nickname  string 下单用户昵称  phone string 下单用户手机  order_status integer
     订单状态，0待付款，1待使用，2待评价，3已完成，4退款中，5退款成功，6退款失败(待使用)，7已过期 */
    
    self.inforDict = dict;
    
    self.orderNoLabel.text = dict[@"order_no"];
    self.nameLabel.text = dict[@"nickname"];
    self.phoneLabel.text = dict[@"phone"];
    self.statusLabel.text = dict[@"order_status"];
    NSInteger type = [dict[@"order_status_type"] integerValue];
    if (type == 1 || type == 6) {
        self.titleLabel.text = @"确定消费该订单？";
    }else{
        self.titleLabel.text = @"订单概况";
    }
    
}


@end
