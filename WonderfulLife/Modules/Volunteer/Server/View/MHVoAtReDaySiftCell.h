//
//  MHVoAtReDaySiftCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVoAttendanceRecordSiftModel;
@interface MHVoAtReDaySiftCell : UITableViewCell
@property (nonatomic,strong) MHVoAttendanceRecordSiftModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
