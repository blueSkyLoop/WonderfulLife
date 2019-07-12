//
//  MHVolActivityRequestHandler.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityRequestHandler.h"
#import "MHNetworking.h"
#import "YYModel.h"
#import "MHUserInfoManager.h"
#import "MHVolunteerUserInfo.h"

#import "MHActivityModifyModel.h"
#import "MHVolActivityListModel.h"
#import "MHActivityTemplateModel.h"
#import "MHVolActivityDetailsModel.h"
#import "MHVolActivityApplyListModel.h"
@implementation MHVolActivityRequestHandler

+ (void)activityDetailsRequest:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id action_team_ref_id:(NSNumber *)action_team_ref_id ActivityDetailsBlock:(ActivityDetailsBlock)callBack failure:(void(^)(NSString *errmsg))failure{
    NSDictionary *dic = @{@"action_id":action_id,@"volunteer_id":volunteer_id,@"action_team_ref_id":action_team_ref_id};
    
    [[MHNetworking shareNetworking] post:@"volunteer/action/detail" params:dic success:^(id data) {
        MHVolActivityDetailsModel * model = [MHVolActivityDetailsModel yy_modelWithDictionary:data];
        callBack(model,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (RACSignal *)pullActivityListWithState:(NSNumber*)state page:(NSNumber *)page {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:page forKey:@"page"];
    [params setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
    [params setValue:state forKey:@"action_state"];

    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[MHNetworking shareNetworking] post:@"volunteer/action/list" params:params success:^(NSDictionary *data) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[MHVolActivityListModel class] json:data[@"list"]];
            [MHVolunteerUserInfo sharedInstance].volunteer_is_captain = data[@"is_captain"];
            [subscriber sendNext:RACTuplePack(@1,data[@"has_next"],list)];//元组（是否成功，是否有下一页，数据列表）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,@0,errmsg)];//元组（是否成功，是否有下一页，数据列表）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pushEnrollActivityId:(id)x {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    RACTupleUnpack(NSNumber *team_id,NSNumber *action_id) = x;
    [params setValue:team_id forKey:@"team_id"];
    [params setValue:action_id forKey:@"action_id"];
    [params setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[MHNetworking shareNetworking] post:@"volunteer/action/apply/create" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];

}

+ (RACSignal *)pushEnrollCancelActivityId:(id)x {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    RACTupleUnpack(NSNumber *team_id,NSNumber *action_id) = x;
    [params setValue:action_id forKey:@"action_id"];
    [params setValue:team_id forKey:@"team_id"];
    [params setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[MHNetworking shareNetworking] post:@"volunteer/action/apply/delete" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullActivityModifyInfoWithId:(id)x {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    RACTupleUnpack(NSNumber *team_id,NSNumber *action_id) = x;
    [params setValue:team_id forKey:@"team_id"];
    [params setValue:action_id forKey:@"action_id"];
    [params setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [[MHNetworking shareNetworking] post:@"volunteer/action/get" params:params success:^(id data) {
            MHActivityModifyModel * model = [MHActivityModifyModel yy_modelWithDictionary:data];
            [subscriber sendNext:RACTuplePack(@1,model)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];

}

+ (void)activityDetailsApplyCreateWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id team_id:(NSNumber *)team_id ActivityDetailsBlock:(ActivityDetailsApply)callBack failure:(void(^)(NSString *errmsg))failure{
    NSDictionary *dic = @{@"action_id":action_id,@"volunteer_id":volunteer_id,@"team_id":team_id};
    [[MHNetworking shareNetworking] post:@"volunteer/action/apply/create" params:dic success:^(id data) {
        callBack(YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];

}


+ (void)activityDetailsApplyDeleteWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id team_id:(NSNumber *)team_id ActivityDetailsBlock:(ActivityDetailsApply)callBack failure:(void(^)(NSString *errmsg))failure{
    NSDictionary *dic = @{@"action_id":action_id,@"volunteer_id":volunteer_id,@"team_id":team_id};
    [[MHNetworking shareNetworking] post:@"volunteer/action/apply/delete" params:dic success:^(id data) {
        callBack(YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)activityCancelWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id
         ActivityBlock:(ActivityBlock)callBack failure:(void(^)(NSString *errmsg))failure{
    NSDictionary *dic = @{@"action_id":action_id,@"volunteer_id":volunteer_id};
    [[MHNetworking shareNetworking] post:@"volunteer/action/undo" params:dic success:^(id data) {
        callBack(YES);
    }failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)acticityApplyList:(NSNumber *)action_team_ref_id ActivityApplyListBlock:(ActivityApplyListBlock)callBack failure:(void (^)(NSString *))failure {
    NSDictionary *dic = @{@"action_team_ref_id":action_team_ref_id};
    [[MHNetworking shareNetworking] post:@"volunteer/action/apply/list" params:dic success:^(id data) {
        MHVolActivityApplyListModel * model = [MHVolActivityApplyListModel yy_modelWithJSON:data];
        callBack(model,YES);
    }failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (RACSignal *)updateActivityModifyInfoWithJson:(id)json {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [[MHNetworking shareNetworking] post:@"volunteer/action/modify" params:json success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullActivityInfoTemplateWithTeamJson:(id)teamJson {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [[MHNetworking shareNetworking] post:@"volunteer/action/template/get" params:teamJson success:^(id data) {
            MHActivityTemplateModel * model = [MHActivityTemplateModel yy_modelWithDictionary:data];
            [subscriber sendNext:RACTuplePack(@1,model)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)commitNewActivityInfoWithVolunteerJson:(id)volunteerJson;{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [[MHNetworking shareNetworking] post:@"volunteer/action/submit" params:volunteerJson success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data,@0)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg,@(errcode))];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (void)pullActivityTeamListWithVolunteer_id:(NSNumber *)volunteer_id ActivityDetailsBlock:(void(^)(id data))callBack failure:(void(^)(NSString *errmsg))failure{
    NSDictionary *dic = @{@"volunteer_id":volunteer_id};
    
    [[MHNetworking shareNetworking] post:@"volunteer/action/team/list" params:dic success:^(id data) {
        callBack(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)pullActivityTypeListWithVolunteer_id:(NSNumber *)volunteer_id  teamID:(id)teamID ActivityDetailsBlock:(ActivityDetailsBlock)callBack failure:(void(^)(NSString *errmsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:volunteer_id forKey:@"volunteer_id"];
    [dic setValue:teamID forKey:@"team_id"];
    
    [[MHNetworking shareNetworking] post:@"volunteer/action/type/list" params:dic success:^(id data) {
        callBack(data,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}
@end
