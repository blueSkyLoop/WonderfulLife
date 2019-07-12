//
//  MHVoSerJoinedTeamCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHVoSerJoinedTeamDelegate <NSObject>
@optional
- (void)didClickMyAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)didClickAllAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)didClickRegistAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@class MHVolSerTeamModel;
@interface MHVoSerJoinedTeamCell : UITableViewCell
/// <#summary#>
@property (weak,nonatomic) id<MHVoSerJoinedTeamDelegate> delegate;
@property (strong,nonatomic) MHVolSerTeamModel *model;
/// <#summary#>
@property (strong,nonatomic) NSIndexPath *indexPath;
@end
