//
//  MHVolCheckTimeCell.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolCheckTimeEnum.h"
@class MHVolServiceTimePerMonthDetail ;
@interface MHVolCheckTimeCell : UITableViewCell

@property (nonatomic, assign) MHVolCheckTimeType VolCheckType;

@property (strong,nonatomic) MHVolServiceTimePerMonthDetail *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
