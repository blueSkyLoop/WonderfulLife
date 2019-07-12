//
//  MHVoSeAttendanceRegisterCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeAttendanceRegisterCell.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import "MHVolSerReamListModel.h"
#import "MHVolSerAttendanceRecordModel.h"
#import "UIImageView+WebCache.h"
#import "NSObject+isNull.h"
@interface MHVoSeAttendanceRegisterCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, weak)IBOutlet UILabel *captainLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captainLabWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic, strong) MHVoSeAttendanceRegisterCommitModel *commitDataModel;
@end

@implementation MHVoSeAttendanceRegisterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"CellId";
    MHVoSeAttendanceRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVoSeAttendanceRegisterCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.timeCount = 0;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _subBtn.hidden = YES;
    
    _captainLab.textColor = MColorBlue;
    _captainLab.layer.masksToBounds = YES;
    _captainLab.layer.cornerRadius = 3;
    _captainLab.layer.borderColor = MColorBlue.CGColor;
    _captainLab.layer.borderWidth = 1;
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)subAction:(UIButton *)sender {
    if (self.timeCount == 0) return;
   
    if (self.timeCount == 1) {
        self.subBtn.hidden = YES;
        if ([self.attendance_details containsObject:self.commitDataModel]) {
            [self.attendance_details removeObject:self.commitDataModel];
        }
        if (self.attendance_details.count == 0) {
            !self.enableCommitButtonBlock ?: self.enableCommitButtonBlock(NO);
        }
    }
    self.timeCount--;
    self.timeLab.text = [NSString stringWithFormat:@"%ld",self.timeCount];
    
    //缓存登记时长标识
    self.model.timeCountFlag = self.timeCount;
}
- (IBAction)addAction:(UIButton *)sender {
    if (![self.attendance_details containsObject:self.commitDataModel]) {
        [self.attendance_details addObject:self.commitDataModel];
    }
    if (self.timeCount == 24) {
        return;
    }
    self.timeCount++;
    self.timeLab.text = [NSString stringWithFormat:@"%ld",self.timeCount];
    
    //缓存登记时长标识
    self.model.timeCountFlag = self.timeCount;
    
    //assign
    self.commitDataModel.service_time = [NSString stringWithFormat:@"%ld",(long)self.timeCount];
    self.commitDataModel.user_id =  [NSString stringWithFormat:@"%@",self.model.id];;
    
    self.subBtn.hidden = NO;
    
    !self.enableCommitButtonBlock ?: self.enableCommitButtonBlock(YES);
}

#pragma mark - Setter
- (void)setModel:(MHVolSerReamListModel *)model {
    _model = model;
    
    self.nameLab.text = _model.name;
    if (![NSObject isNull:_model.role_name]) {
        self.captainLab.text =  _model.role_name;
    }
    if ([_model.is_captain isEqualToString:@"0"]) {
        self.captainLab.hidden = YES;
    } else if ([_model.is_captain isEqualToString:@"1"]) {
        self.captainLabWidth.constant = 35;
        self.captainLab.hidden = NO;
    } else if ([_model.is_captain isEqualToString:@"2"]) {
        self.captainLabWidth.constant = 50;
        self.captainLab.hidden = NO;
    }
    
    //标识
    self.commitDataModel = _model.commitDataModel;
    
    self.timeCount = _model.timeCountFlag;
    self.timeLab.text = [NSString stringWithFormat:@"%ld",self.timeCount];
    if (model.headphoto_s_url.length) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url] placeholderImage:MAvatar];
    }
    
    if (self.timeCount == 0) self.subBtn.hidden = YES;
    else self.subBtn.hidden = NO;
}


@end


@implementation MHVoSeAttendanceRegisterCommitModel


@end
