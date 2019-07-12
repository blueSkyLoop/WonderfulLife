//
//  MHVolActivityTeamsSelectCell.m
//  WonderfulLife
//
//  Created by zz on 16/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityTeamsSelectCell.h"

@implementation MHVolActivityTeamsSelectCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolActivityTeamsSelectCell";
    MHVolActivityTeamsSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolActivityTeamsSelectCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    UIEdgeInsets insets = {0, 24, 0, 24};
    cell.separatorInset = insets;
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
