//
//  MHStoreRefundReasonCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundReasonCell.h"
#import "LCommonModel.h"
#import "MHStoreRefundReasonModel.h"

@implementation MHStoreRefundReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
}

- (void)mh_configCellWithInfor:(MHStoreRefundReasonModel *)model{
    self.resonLabel.text = model.reason;
    self.selectBtn.selected = model.isSelected;
}

@end
