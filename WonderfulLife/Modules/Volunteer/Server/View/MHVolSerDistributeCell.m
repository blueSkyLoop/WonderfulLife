//
//  MHVolSerDistributeCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerDistributeCell.h"
#import "MHMacros.h"
#import "MHVolSerReviewDistributeTeamModel.h"
@interface MHVolSerDistributeCell ()
@property (weak, nonatomic) IBOutlet UIView *box;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;

@property (nonatomic, assign, getter=isSelectFlag) BOOL selectFlag;
@end

@implementation MHVolSerDistributeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolSerDistributeCellId";
    MHVolSerDistributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolSerDistributeCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.box.layer.masksToBounds = YES;
    self.box.layer.cornerRadius = 6;
    self.box.layer.borderColor = MColorSeparator.CGColor;
    self.box.layer.borderWidth = 1;

}



- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.selectFlag = sender.selected;
    !self.selectBlock ?: self.selectBlock(self.model, sender.selected);
}

- (void)setModel:(MHVolSerReviewDistributeTeamModel *)model {
    _model = model;
    
    _teamName.text = _model.team_name;
    _descLab.text = _model.activity_summary;
    _name.text = _model.captain_name;
    _count.text = [NSString stringWithFormat:@"%@人",_model.headcount];
    
     self.selectBtn.selected  = _model.selectFlag;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
