//
//  MHActivityActionView.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"
typedef void(^ActivityAction)(void);

typedef NS_ENUM(NSInteger, MHActivityActionViewType){

    /** 提交修改*/
    MHActivityActionViewTypeRepairNormal  = 0,

    /** 提交修改*/
    MHActivityActionViewTypeRepairDisabled = 1,
    
    /** 提交考勤修改*/
    MHActivityActionViewTypeAttendanceNormal = 2,
    
    /** 提交考勤修改*/
    MHActivityActionViewTypeAttendanceDisabled = 3 ,
    
    /** 队长登记考勤*/
    MHActivityActionViewTypeRegAttendance = 4,
    
    /** 队长管理报名*/
    MHActivityActionViewTypeManagementSignUp = 5,
    
    /** 队员报名 可报名*/
    MHActivityActionViewTypeMembersSignUpNormal = 6,
    
    /** 队员报名  满人*/
    MHActivityActionViewTypeMembersSignUpFill = 7,
    
    /** 队员报名 取消*/
    MHActivityActionViewTypeMembersSignUpCancel = 8,
    
    /** 提交发布*/
    MHActivityActionViewTypeActivityPublish = 9,
    
    /** 提交发布*/
    MHActivityActionViewTypeActivityPublishDisabled = 10,
};


@interface MHActivityActionView : UIView

@property (nonatomic, copy)ActivityAction RightHandler;
@property (weak, nonatomic) IBOutlet MHThemeButton *doneBtn;





+ (instancetype)activityActionViewWithStatus:(MHActivityActionViewType)type qty:(NSInteger)qty  sty:(NSInteger)sty handler:(ActivityAction)handler;

/** 更新控件最新状态*/
- (void)setConfigWithType:(MHActivityActionViewType)type qty:(NSInteger)qty  sty:(NSInteger)sty;
@end
