//
//  MHReportRepairListCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@interface MHReportRepairListCell()

@property (nonatomic,strong)MHReportRepairListModel *model;

@end

@implementation MHReportRepairListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    self.firtButton.layer.borderWidth = 1;
    self.firtButton.layer.borderColor = [MRGBColor(132, 145, 166) CGColor];
    self.firtButton.layer.cornerRadius = 2;
    self.firtButton.layer.masksToBounds = YES;
    
    self.secondButton.layer.borderWidth = 1;
    self.secondButton.layer.borderColor = [MRGBColor(132, 145, 166) CGColor];
    self.secondButton.layer.cornerRadius = 2;
    self.secondButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cellButtonClikAction:(UIButton *)sender {
    NSInteger index = 0;
    if(self.model.is_show_activate && sender == self.firtButton){
        index = 3;
    }else if(sender == self.secondButton){
        if(self.model.is_show_cancel){
            index = 1;
        }else if(self.model.is_show_evaluate){
            index = 2;
        }
    }
    if(self.cellClikBlock){
        __weak __typeof(self)weakSelf = self;
        self.cellClikBlock(sender,index ,weakSelf.model);
    }
}

- (void)mh_configCellWithInfor:(MHReportRepairListModel *)model{
    
    self.model = model;
    
    self.titleLabel.text = model.repairment_category_name;
    self.stateLabel.text = model.repairment_status_name;
    self.stateLabel.textColor = [model statusUIColor];
    self.detailLabel.text = model.repairment_cont;
    self.timeLabel.text = model.times;
    if(model.is_show_cancel){
        self.secondButton.hidden = NO;
        [self.secondButton setTitle:@"取 消" forState:UIControlStateNormal];
    }else{
        if(model.is_show_evaluate){
            self.secondButton.hidden = NO;
            [self.secondButton setTitle:@"去评价" forState:UIControlStateNormal];
        }else{
            self.secondButton.hidden = YES;
        }
    }
    
    self.firtButton.hidden = model.is_show_activate?NO:YES;
    
    
}

@end
