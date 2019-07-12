//
//  MHVolActivityDeatilsTimeCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVolActivityDetailsModel.h"
@interface MHVolActivityDeatilsTimeCell : UITableViewCell

@property (nonatomic, strong) MHVolActivityDetailsModel  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
