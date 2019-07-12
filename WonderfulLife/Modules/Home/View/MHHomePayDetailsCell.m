//
//  MHHomePayDetailsCell.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayDetailsCell.h"

#import "MHHoPayExpensesModel.h"
#import "MHUnpaySubjectModel.h"

@interface MHHomePayDetailsCell ()
/**
 费用名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 费用额
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation MHHomePayDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUnpayModel:(MHUnpaySubjectModel *)unpayModel {
    unpayModel = unpayModel;
    
    // 设置数据
    self.nameLabel.text = unpayModel.pay_project;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",unpayModel.fee];
}

- (void)setPaidModel:(MHHoPayExpensesModel *)paidModel{
    _paidModel = paidModel;
    self.nameLabel.text = paidModel.pay_project;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",paidModel.pay_amount];
}

@end
