//
//  MHVolActivityDetailsInfoCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolActivityDetailsModel ,MHVolSerTeamMember;

@protocol MHVolActivityDetailsInfoCellDelegate <NSObject>

@optional
- (void)InfoCellDidClickIcon:(MHVolSerTeamMember *)model;

@end


@interface MHVolActivityDetailsInfoCell : UITableViewCell

@property (nonatomic, weak) id <MHVolActivityDetailsInfoCellDelegate> delegate ;

@property (nonatomic, strong) MHVolActivityDetailsModel  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
