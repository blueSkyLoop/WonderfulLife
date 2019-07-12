//
//  MHVoSerIntegralDetailsCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolunteerScoreRecord;
@interface MHVoSerIntegralDetailsCell : UITableViewCell

@property (nonatomic, strong) MHVolunteerScoreRecord  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
