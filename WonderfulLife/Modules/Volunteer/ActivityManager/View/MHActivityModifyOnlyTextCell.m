//
//  MHActivityModifyOnlyTextCell.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyOnlyTextCell.h"

@interface MHActivityModifyOnlyTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemContentLabel;

@end

@implementation MHActivityModifyOnlyTextCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHActivityModifyOnlyTextCell";
    MHActivityModifyOnlyTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHActivityModifyOnlyTextCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    self.itemNameLabel.text = model[@"title"];
    self.itemContentLabel.text = model[@"content"];
    if (self.boldFont) {
        self.itemNameLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightSemibold];
        self.itemContentLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightSemibold];
    }else {
        self.itemNameLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightRegular];
        self.itemContentLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightRegular];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
