//
//  MHAttendanceRegisterTableViewCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHAttendanceRegisterTableViewCellTypeRegister,
    MHAttendanceRegisterTableViewCellTypeModify,
} MHAttendanceRegisterTableViewCellType;

@class MHVoAttendanceRecordDetailCrewModel;

@protocol MHAttendanceRegisterTableViewCellDelegate <NSObject>

- (void)recordCrewWithModel:(MHVoAttendanceRecordDetailCrewModel *)model;

@end

@interface MHAttendanceRegisterTableViewCell : UITableViewCell
@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *model;
@property (nonatomic,weak) id<MHAttendanceRegisterTableViewCellDelegate> delegate;
@property (nonatomic,assign) MHAttendanceRegisterTableViewCellType type;

@end
