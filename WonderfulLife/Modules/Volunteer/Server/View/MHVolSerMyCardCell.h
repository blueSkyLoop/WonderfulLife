//
//  MHVoMyCardCell.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/8/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolSerMyCardModel;
@interface MHVolSerMyCardCell : UITableViewCell
@property (nonatomic, strong) MHVolSerMyCardModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
