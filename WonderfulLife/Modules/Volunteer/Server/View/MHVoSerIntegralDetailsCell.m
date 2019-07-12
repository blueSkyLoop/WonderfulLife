//
//  MHVoSerIntegralDetailsCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerIntegralDetailsCell.h"
#import "MHVoSerIntegralDetailsModel.h"

#import "NSDate+ChangeString.h"
#import "NSString+CaptureString.h"
#import "MHMacros.h"
@interface MHVoSerIntegralDetailsCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *serIntegraLB;

@end

@implementation MHVoSerIntegralDetailsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVoSerIntegralDetailsCell";
    
    MHVoSerIntegralDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

- (void)setModel:(MHVolunteerScoreRecord *)model{
    _model = model;
    self.nameLB.text = model.data_type ;
    
    NSString *dateStr = [NSDate mh_AllDateWithString:model.create_datetime];
    
    self.dateLB.text = dateStr ;
    self.nameLB.text = model.data_type ;
    self.serIntegraLB.text = model.change_score;
    BOOL isAdd = [NSString mh_stringCaptureWithAllString:model.change_score keyword:@"+"];
    
    if (isAdd) {// 正数
        self.serIntegraLB.textColor = MColorTitle;
    }else{ // 负数
        self.serIntegraLB.textColor = MColorMainGradientStart;
    }
    
}
@end
