//
//  MHVolunteerSupportCell.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerSupportCell.h"
#import "MHVolunteerSupportModel.h"
@interface MHVolunteerSupportCell()

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (weak, nonatomic) IBOutlet UILabel *supportLB;

@end
@implementation MHVolunteerSupportCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"MHVolunteerSupportCell";
    
    MHVolunteerSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil]forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(MHVolunteerSupportModel *)model{
    _model = model;

    if (model.is_own == 1) {
        self.selectImage.image = [UIImage imageNamed:@"vo_supportSelect"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"vo_supportNoSelect"];
    }
    self.supportLB.text = model.support_name;
}

@end
