//
//  MHHomePayNoteCell.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayNoteCell.h"
#import "MHUnpaySubjectModel.h"

@interface MHHomePayNoteCell ()
/**
 时间月份
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 缴费金额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MHHomePayNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(MHUnpaySubjectModel *)model{
    _model = model;
    self.timeLabel.text = model.date.length ? model.date : model.datetime;
    self.moneyLabel.text = model.fee;
}

@end




