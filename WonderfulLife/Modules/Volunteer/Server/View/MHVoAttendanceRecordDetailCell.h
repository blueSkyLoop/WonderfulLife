//
//  MHVoAttendanceRecordDetailCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYPhotosView.h"

#import "MHVoAttendanceRecordDetailModel.h"
typedef enum : NSUInteger {
    MHVoAttendanceRecordDetailCellTypeDetail,
    MHVoAttendanceRecordDetailCellTypeRegister,
} MHVoAttendanceRecordDetailCellType;


@interface MHVoAttendanceRecordDetailCell : UITableViewCell
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) MHVoAttendanceRecordDetailModel *model;
@end


@interface MHVoAttendanceRecordDetailPhotoCell : UITableViewCell
@property (nonatomic,assign) MHVoAttendanceRecordDetailCellType type;
@property (strong, nonatomic) PYPhotosView *photosView;//暴露给控制器做代理
@property (nonatomic,strong) MHVoAttendanceRecordDetailModel *model;
@end

typedef enum : NSUInteger {
    MHVoAttendanceRecordDetailContentTypeActivityIntroduce,
    MHVoAttendanceRecordDetailContentTypeAttendanceRemarks,
    MHVoAttendanceRecordDetailContentTypeAttendanceAudit,

} MHVoAttendanceRecordDetailRemarksType;


@interface MHVoAttendanceRecordDetailRemarksCell : UITableViewCell
@property (nonatomic,assign) MHVoAttendanceRecordDetailCellType type;
@property (nonatomic,assign) MHVoAttendanceRecordDetailRemarksType contentType;
@property (nonatomic,weak) UILabel *remarksLabel;
@property (nonatomic,copy) MHVoAttendanceRecordDetailModel *model;

@end

typedef enum : NSUInteger {
    MHVoAttendanceRecordDetailMemberCellTypeTime,

    MHVoAttendanceRecordDetailMemberCellTypeScore
} MHVoAttendanceRecordDetailMemberCellType;
@interface MHVoAttendanceRecordDetailMemberCell : UITableViewCell
@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *model;
@property (nonatomic,assign) MHVoAttendanceRecordDetailMemberCellType type;

@end


