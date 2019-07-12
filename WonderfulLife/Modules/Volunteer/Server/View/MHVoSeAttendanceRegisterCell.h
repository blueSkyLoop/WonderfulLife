//
//  MHVoSeAttendanceRegisterCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVolSerReamListModel, MHVoSeAttendanceRegisterCommitModel;
@interface MHVoSeAttendanceRegisterCell : UITableViewCell
@property (nonatomic, copy) void(^enableCommitButtonBlock)(BOOL enable);
@property (nonatomic, strong) MHVolSerReamListModel *model;
@property (nonatomic, strong) NSMutableArray <MHVoSeAttendanceRegisterCommitModel*>*attendance_details;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@interface MHVoSeAttendanceRegisterCommitModel : NSObject
/** 姓名 */
@property (nonatomic, copy) NSString *real_name;

/** 服务时长 */
@property (nonatomic, copy) NSString *service_time;

/** 用户ID */
@property (nonatomic, copy) NSString *user_id;
@end
