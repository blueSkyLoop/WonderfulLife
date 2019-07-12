//
//  MHVolunteerSupportCell.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolunteerSupportModel;
@interface MHVolunteerSupportCell : UITableViewCell

@property (nonatomic, strong) MHVolunteerSupportModel  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
