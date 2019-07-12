//
//  MHVoAttendanceRegisterCommitView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /** 显示时长*/
    MHVoAttendanceRegisterCommitViewTypeNormal,
    
    /** 显示未分配积分*/
    MHVoAttendanceRegisterCommitViewTypeContract
    
} MHVoAttendanceRegisterCommitViewType;

@protocol MHVoAttendanceRegisterCommitViewDelegate <NSObject>

- (void)commitAttendance;

@end
@interface MHVoAttendanceRegisterCommitView : UIView
+ (instancetype)attendanceRegisterCommitView;
@property (nonatomic,assign) MHVoAttendanceRegisterCommitViewType type;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) CGFloat unAllocScore;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic,weak) id<MHVoAttendanceRegisterCommitViewDelegate> delegate;

/** 暂时处理虚拟账号是否显示积分错误 */
@property (nonatomic, assign) BOOL isShow_UndistributedScore;

@end
