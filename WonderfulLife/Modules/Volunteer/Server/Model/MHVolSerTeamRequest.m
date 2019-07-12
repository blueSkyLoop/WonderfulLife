//
//  MHVolSerTeamRequest.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerTeamRequest.h"
#import "MHVoSerTeamManager.h"
#import "MHNetworking.h"

#import "MHVolSerVolInfo.h"
#import "MHSerTeamDetailModel.h"
#import "MHVolSerTeamModel.h"
#import <YYModel.h>

#import "NSArray+MHOperation.h"


@implementation MHVolSerTeamRequest

+ (void)loadVolSerTeamWithCallBack:(MHVolSerTeamListCallBack)callBack {
    [[MHNetworking shareNetworking] post:@"volunteer/myteam"
                                  params:nil
                                 success:^(NSDictionary *data) {
                                     NSArray *pass_list = [NSArray yy_modelArrayWithClass:[MHVolSerTeamModel class] json:data[@"pass_list"]];
                                     NSArray *approving_list = [NSArray yy_modelArrayWithClass:[MHVolSerTeamModel class] json:data[@"approving_list"]];
                                     NSArray *un_pass_list = [NSArray yy_modelArrayWithClass:[MHVolSerTeamModel class] json:data[@"un_pass_list"]];
                                     NSArray *quit_list = [NSArray yy_modelArrayWithClass:[MHVolSerTeamModel class] json:data[@"quit_list"]];
                                     NSArray *withdraw_list = [NSArray yy_modelArrayWithClass:[MHVolSerTeamModel class] json:data[@"withdraw_list"]];
                                     
                                     
                                     
                                     //                                     / 志愿者在服务队的角色，0表示队员，1表示队长，9表示总队长
                                     //                                     BOOL hasButton =
                                     MHVoSerTeamManager *model = [MHVoSerTeamManager new];
                                     model.isShowJoinBtn = [MHVolSerTeamModel hasButtonWithArray:[pass_list mh_mergeArray:approving_list]]; ;
                                     
                                     for (MHVolSerTeamModel *model in pass_list)
                                         model.type = MHVolSerTeamPassd;
                                     for (MHVolSerTeamModel *model in approving_list)
                                         model.type = MHVolSerTeamApproving;
                                     for (MHVolSerTeamModel *model in un_pass_list)
                                         model.type = MHVolSerTeamUnPass;
                                     for (MHVolSerTeamModel *model in quit_list)
                                         model.type = MHVolSerTeamQuit;
                                     for (MHVolSerTeamModel *model in withdraw_list)
                                         model.type = MHVolSerTeamWithdraw;
                                     
                                     // 所有不同状态的数组归类
                                     model.teams  = [[[[pass_list mh_mergeArray:approving_list] mh_mergeArray:un_pass_list]  mh_mergeArray:quit_list] mh_mergeArray:withdraw_list];
                                     
                                     callBack(YES,model);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,errmsg);
                                 }];
}

+ (void)loadVolSerItemWithCallBack:(MHVolSerItemListCallBack)callBack {
    //    NSDictionary *dic = @{@"user_id":user_id,@"activity_id":activity_id};
    [[MHNetworking shareNetworking] post:@"volunteer/info"
                                  params:nil
                                 success:^(NSDictionary *data) {
                                     callBack(YES,[MHVolSerVolInfo yy_modelWithJSON:data]);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,errmsg);
                                 }];
}



+ (void)loadCustomCardWithDic:(NSMutableDictionary *)dic
                              callBack:(MHVolSerCustomCardCallBack)callBack {
    [[MHNetworking shareNetworking] post:@"volunteer/info"
                                  params:dic
                                 success:^(NSDictionary *data) {
                                     callBack(YES,[MHVolSerVolInfo yy_modelWithJSON:data]);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,errmsg);
                                 }];
}

+ (void)loadVolSerTeamWithId:(NSNumber *)team_id
                    callBack:(MHVolSerTeamDetailCallBack)callBack {
    NSDictionary *dic = @{@"team_id":team_id};
    [[MHNetworking shareNetworking] post:@"volunteer/team/detail"
                                  params:dic
                                 success:^(NSDictionary *data) {
                                     callBack(YES,[MHSerTeamDetailModel yy_modelWithJSON:data]);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,errmsg);
                                 }];
}

+ (void)loadVolSerItemWithId:(NSNumber *)item_id
                    callBack:(MHVolSerItemDetailCallBack)callBack {
    NSDictionary *dic = @{@"activity_id":item_id};
    [[MHNetworking shareNetworking] post:@"volunteer/activity/detail"
                                  params:dic
                                 success:^(NSDictionary *data) {
                                     callBack(YES,[MHSerTeamDetailModel yy_modelWithJSON:data]);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,errmsg);
                                 }];
}



+ (void)loadVolSerTeamQuitWithId:(NSNumber *)team_id
                          reason:(NSString *)reason
                        callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack{
    [[MHNetworking shareNetworking]
     post:@"volunteer/team/quit"
     params:@{@"team_id":team_id,@"reason":reason}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}


+ (void)loadVolSerIsWithdrawWithId:(NSNumber *)apply_id
                          callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack{
    [[MHNetworking shareNetworking]
     post:@"volunteer/activity/isWithdraw"
     params:@{@"apply_id":apply_id}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}


+ (void)loadVolSerWithdrawWithId:(NSNumber *)activity_id
                        callBack:(MHVolSerTeamDetailFooterActionCallBack)callBack{
    [[MHNetworking shareNetworking]
     post:@"volunteer/activity/withdraw"
     params:@{@"activity_id":activity_id}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}



+(void)applyJoinActiveId:(NSString *)activity_ids
                callBack:(MHVolSerTeamApplyJoinActiveCallBack)callBack {
    [[MHNetworking shareNetworking]
     post:@"volunteer/activity/apply"
     params:@{@"activity_ids":activity_ids}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}

+ (void)deleteMemberWithVolunteer_id:(NSNumber *)volunteer_id
                              teamId:(NSNumber *)team_id
                           delReason:(NSString *)reason
                            callBack:(MHVolSerTeamMemberDeleteCallBack)callBack {
    // reason ：删除原因
    [[MHNetworking shareNetworking]
     post:@"volunteer/team/member/delete"
     params:@{@"volunteer_id":volunteer_id,@"team_id":team_id,@"reason":reason}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}

@end
