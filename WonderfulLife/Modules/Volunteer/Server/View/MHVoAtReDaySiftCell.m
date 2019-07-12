//
//  MHVoAtReDaySiftCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAtReDaySiftCell.h"
#import "MHVoAttendanceRecordSiftModel.h"

@interface MHVoAtReDaySiftCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MHVoAtReDaySiftCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setModel:(MHVoAttendanceRecordSiftModel *)model{
    _model = model;
    if (_indexPath.row == 0) {
        self.label.text = @"已审核";
        self.button.selected = model.attendance_status == 1;
        
    }else if (_indexPath.row == 1){
        self.label.text = @"待审核";
        self.button.selected = model.attendance_status == 0;
    }else if (_indexPath.row == 2){
        self.label.text = @"不通过";
        self.button.selected = model.attendance_status == 2;
    }

}

#pragma mark - 按钮点击
- (IBAction)buttonSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        return;
    }
    if (_indexPath.row == 0) {
        _model.attendance_status = 1;
    }else if (_indexPath.row ==1){
        _model.attendance_status = 0;
    }else if (_indexPath.row == 2){
        _model.attendance_status = 2;
    }
    UITableView *tableView = (UITableView *)self.superview.superview;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:_indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







