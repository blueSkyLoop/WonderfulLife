//
//  MHVolSerTeamRequest.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVoSerTeamManager ;
typedef void(^MHVolSerTeamListCallBack)(BOOL success, id info);
typedef void(^MHVolSerItemListCallBack)(BOOL success, id info);
typedef void(^MHVolSerCustomCardCallBack)(BOOL success, id info);
typedef void(^MHVolSerTeamDetailCallBack)(BOOL success, id info);
typedef void(^MHVolSerItemDetailCallBack)(BOOL success, id info);
typedef void(^MHVolSerTeamApplyJoinActiveCallBack)(BOOL success, id info);
typedef void(^MHVolSerTeamMemberDeleteCallBack)(BOOL success, id info);

typedef void(^MHVolSerTeamDetailFooterActionCallBack)(BOOL success, id info);



@interface MHVolSerTeamRequest : NSObject
//服务队列表
+ (void)loadVolSerTeamWithCallBack:(MHVolSerTeamListCallBack)callBack;
//服务队详情
+ (void)loadVolSerTeamWithId:(NSNumber *)team_id
                    callBack:(MHVolSerTeamDetailCallBack)callBack;
//服务项目列表
+ (void)loadVolSerItemWithCallBack:(MHVolSerItemListCallBack)callBack;
//服务项目详情
+ (void)loadVolSerItemWithId:(NSNumber *)item_id
                    callBack:(MHVolSerItemDetailCallBack)callBack;

//退出服务队（队员专用）
+ (void)loadVolSerTeamQuitWithId:(NSNumber *)team_id
                          reason:(NSString *)reason
                        callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack;

// 是否已经撤回
+ (void)loadVolSerIsWithdrawWithId:(NSNumber *)apply_id
                          callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack;
// 撤回服务队申请
+ (void)loadVolSerWithdrawWithId:(NSNumber *)activity_id
                        callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack;

//个人卡片
+ (void)loadCustomCardWithDic:(NSMutableDictionary *)dic
                     callBack:(MHVolSerCustomCardCallBack)callBack;

+(void)applyJoinActiveId:(NSString *)activity_ids
                callBack:(MHVolSerTeamApplyJoinActiveCallBack)callBack;

// 删除队员
+ (void)deleteMemberWithVolunteer_id:(NSNumber *)volunteer_id
                              teamId:(NSNumber *)team_id
                           delReason:(NSString *)reason
                            callBack:(MHVolSerTeamMemberDeleteCallBack)callBack;
@end
