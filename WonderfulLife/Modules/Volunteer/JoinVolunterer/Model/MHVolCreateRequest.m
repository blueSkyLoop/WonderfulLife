//
//  MHVolCreateRequest.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolCreateRequest.h"
#import "MHNetworking.h"
#import "MHVolActiveModel.h"
#import "MHVolCreateModel.h"
#import <YYModel.h>
#import "MHAliyunManager.h"
#import "MHConst.h"
#import "MHUserInfoManager.h"
#import "AppDelegate.h"
#import "MHVolSerItemManager.h"

typedef void(^JFUploadImageCallBack)(void);


@implementation MHVolCreateRequest

+ (void)sendCommunityId:(NSNumber *)community_id
               callBack:(MHVolCreateActivteBlock)callBack {
    [[MHNetworking shareNetworking]
     post:@"volunteer/activity/list2"
     params:@{@"community_id":community_id}
     success:^(id data) {
        MHVolSerItemManager *manager = [MHVolSerItemManager yy_modelWithJSON:data];
         
         manager.isSelectCity = !manager.join_team_count;
         
         callBack(manager,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(nil,errmsg);
     }];
}

+ (void)createdVolunterCallBack:(MHVolCreateFinishCallBlock)callBack {
    [[MHAliyunManager sharedManager] uploadImageToAliyunWithImage:[MHVolCreateModel sharedInstance].image success:^(MHOOSImageModel *imageModel) {
        MHVolCreateModel *createModel = [MHVolCreateModel sharedInstance];
        createModel.img_width = @(imageModel.width);
        createModel.img_height = @(imageModel.height);
        createModel.file_id = imageModel.name;
        createModel.file_url = imageModel.url;
        
        NSDictionary *dic = [MHVolCreateModel toDictionary];
        
        [[MHNetworking shareNetworking]
         post:@"volunteer/apply/create"
         params:dic
         success:^(NSDictionary * dic) {
             //申请成功，发送通知，更新志愿者首页界面
             [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerHomePageNotification object:nil userInfo:@{kShowInvitePage: @(NO)}];
             [MHUserInfoManager sharedManager].volunteer_id = [dic objectForKey:@"volunteer_id"];
             [MHUserInfoManager sharedManager].serve_community_id = [dic objectForKey:@"serve_community_id"];
             [MHUserInfoManager sharedManager].serve_community_name = [dic objectForKey:@"serve_community_name"];
             
             //更改本地志愿者标识
             [MHUserInfoManager sharedManager].is_volunteer = @1;
             [[MHUserInfoManager sharedManager] saveUserInfoData];
             
             //弹窗需求
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             appDelegate.ignore = YES;
             
             callBack(YES,nil);
         }
         failure:^(NSString *errmsg, NSInteger errcode) {
             callBack(NO,errmsg);
         }];
    } failed:^(NSString *errmsg) {
        callBack(NO,errmsg);
    }];
}

+ (void)applyJoinActiveCallBack:(MHApplyJoinActiveCallBack)callBack {
    [[MHNetworking shareNetworking]
     post:@"volunteer/activity/apply"
     params:@{@"activity_ids":[MHVolCreateModel sharedInstance].activity_list}
     success:^(id data) {
         callBack(YES,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,errmsg);
     }];
}

+ (void)checkHotCityCallBack:(MHCheckCityCallBack)callBack{
    [[MHNetworking shareNetworking]
     post:@"community/checkIsServeCommunity"
     params:@{@"serve_community_id":[MHUserInfoManager sharedManager].serve_community_id}
     success:^(NSDictionary *data) {
    
         BOOL is_serve_community = [[data objectForKey:@"is_serve_community"] boolValue];
         
         callBack(YES,is_serve_community,nil);
     }
     failure:^(NSString *errmsg, NSInteger errcode) {
         callBack(NO,NO,errmsg);
     }];
}

@end
