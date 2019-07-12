//
//  MHReportRepairTypeCell.m
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairTypeCell.h"
#import "MHReportRepairTypeModel.h"

@implementation MHReportRepairTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setSeparatorInset:UIEdgeInsetsZero];
}

- (void)bindViewModel:(id)model {
    MHReportRepairTypeModel *typeModel = model;
    self.titleLabel.text = typeModel.repairment_category_name;
    self.arrowImageView.hidden = ![typeModel.has_next boolValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
