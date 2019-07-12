//
//  MHVolActivityListDataViewModel.h
//  WonderfulLife
//
//  Created by zz on 11/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolActivityListModel;
@interface MHVolActivityListDataViewModel : NSObject
///分队长cell
@property (copy, nonatomic)  NSString   *c_activityTitle;
@property (copy, nonatomic)  NSString   *c_activityState;
@property (copy, nonatomic)  NSString   *c_startOfActivityTime;
@property (copy, nonatomic)  NSString   *c_endOfActivityTime;
@property (copy, nonatomic)  NSString   *c_activityAddress;
@property (copy, nonatomic)  NSString   *c_placesOfActivity;

@property (strong, nonatomic)  UIColor  *c_activityTipsColor;
@property (strong, nonatomic)  UIColor  *c_activityTitleColor;
@property (assign, nonatomic)  CGFloat   c_temporaryHeight;
@property (assign, nonatomic)  BOOL      c_isTemporaryActivity;
@property (assign, nonatomic)  BOOL      c_hasBottomBaseView;
@property (assign, nonatomic)  BOOL      c_isNeedToAttendance;
@property (assign, nonatomic)  BOOL      c_isShowModifyActivity;
//开发型临时活动，分队长需要报名
@property (assign, nonatomic)  BOOL      c_isShowEnrolling;               //是否显示立即报名
@property (assign, nonatomic)  BOOL      c_isShowCancelEnrolling;         //是否显示取消报名

///队友cell
@property (copy  ,nonatomic) NSString   *t_activityTitle;
@property (copy, nonatomic)  NSString   *t_activityState;
@property (copy, nonatomic)  NSString   *t_startOfActivityTime;
@property (copy, nonatomic)  NSString   *t_endOfActivityTime;
@property (copy, nonatomic)  NSString   *t_activityAddress;
@property (copy, nonatomic)  NSString   *t_placesOfActivity;

@property (strong, nonatomic)  UIColor  *t_activityTipsColor;
@property (strong, nonatomic)  UIColor  *t_activityTitleColor;
@property (assign, nonatomic)  CGFloat   t_temporaryHeight;
@property (assign, nonatomic)  BOOL      t_isTemporaryActivity;
@property (assign, nonatomic)  BOOL      t_hasBottomBaseView;
@property (assign, nonatomic)  BOOL      t_isShowEnrolling;

///已结束cell
@property (copy  ,nonatomic) NSString   *e_activityTitle;
@property (copy, nonatomic)  NSString   *e_activityState;
@property (copy, nonatomic)  NSString   *e_startOfActivityTime;
@property (copy, nonatomic)  NSString   *e_endOfActivityTime;
@property (copy, nonatomic)  NSString   *e_activityAddress;
@property (copy, nonatomic)  NSString   *e_placesOfActivity;

@property (strong, nonatomic)  UIColor  *e_activityTipsColor;
@property (strong, nonatomic)  UIColor  *e_activityTitleColor;
@property (assign, nonatomic)  CGFloat   e_temporaryHeight;
@property (assign, nonatomic)  BOOL      e_isTemporaryActivity;
@property (assign, nonatomic)  BOOL      e_hasBottomBaseView;

///Common
@property (strong, nonatomic) NSNumber  *action_team_ref_id;//服务队列关联id
@property (strong, nonatomic) NSNumber  *action_id;
@property (strong ,nonatomic) NSNumber  *activity_team_id;
@property (strong, nonatomic) NSNumber  *team_id;
@property (assign, nonatomic) CGFloat    rowHeight;    //行高
@property (strong, nonatomic) MHVolActivityListModel *model;

- (void)handleCaptainList;
- (void)handleTeammateList;
- (void)handleEndOfActivityList;

@end
