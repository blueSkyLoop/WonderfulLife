//
//  MHVolSerDistributeCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolSerReviewDistributeTeamModel;

@interface MHVolSerDistributeCell : UITableViewCell
@property (nonatomic, copy) void(^selectBlock)(MHVolSerReviewDistributeTeamModel *model, BOOL isSelect);
@property (nonatomic, strong) MHVolSerReviewDistributeTeamModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
