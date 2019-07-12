//
//  MHVolActivityDetailsAddressCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsAddressCell.h"
#import "UILabel+HLLineSpacing.h"
#import "MHVolActivityDetailsModel.h"
@interface MHVolActivityDetailsAddressCell()


@end


@implementation MHVolActivityDetailsAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolActivityDetailsAddressCell";
    MHVolActivityDetailsAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}



- (void)setModel:(MHVolActivityDetailsModel *)model{
    _model = model ;
    self.addressLB.text = model.addr ;
    [self.addressLB hl_setLineSpacing:2.0 text:self.addressLB.text];
}


@end
