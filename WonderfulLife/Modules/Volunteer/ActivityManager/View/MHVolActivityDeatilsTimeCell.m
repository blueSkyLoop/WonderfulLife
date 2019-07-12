//
//  MHVolActivityDeatilsTimeCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDeatilsTimeCell.h"
#import "NSDate+MHCalendar.h"
#import "UILabel+isNull.h"
@interface MHVolActivityDeatilsTimeCell ()
@property (weak, nonatomic) IBOutlet UILabel *beginLB;
@property (weak, nonatomic) IBOutlet UILabel *endLB;

@end

@implementation MHVolActivityDeatilsTimeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolActivityDeatilsTimeCell";
    MHVolActivityDeatilsTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}




- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setModel:(MHVolActivityDetailsModel *)model{
    _model = model;

    NSString *date_begin = [NSDate getDateDisplayString:model.date_begin];
    NSString *date_end = [NSDate getDateDisplayString:model.date_end];

    [self.beginLB mh_isNullWithDataSourceText:model.date_begin allText:[NSString stringWithFormat:@"开始时间：%@",date_begin] isNullReplaceString:@""];
    
    [self.endLB mh_isNullWithDataSourceText:model.date_end allText:[NSString stringWithFormat:@"结束时间：%@",date_end] isNullReplaceString:@""];
}


@end
