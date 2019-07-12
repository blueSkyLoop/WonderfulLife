//
//  MHVolSeverPageViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSeverPageViewModel.h"
#import "MHHUDManager.h"
#import "MHNetworking.h"
#import "MHUserInfoManager.h"

#import "MHVolunteerUserInfo.h"
#import "MHJPushRequestHandle.h"
#import "JPUSHService.h"
#import "MHWeakStrongDefine.h"

@interface MHVolSeverPageViewModel()

@property (nonatomic,strong,readwrite)RACCommand *serverCommand;

@property (nonatomic,strong,readwrite)RACCommand *virtualAccountCommand;

@property (nonatomic,strong,readwrite)RACCommand *attendanceRecordCommand;

@property (nonatomic,strong,readwrite)RACSubject *refreshSubject;


@end

@implementation MHVolSeverPageViewModel

- (void)loadDataWithModel:(MHVolunteerServiceMainModel *)model{
    
    self.model = model;
    
    ///更新新的志愿者单例类的信息，此处更新志愿者角色，0队员、1分队长、9总队长
    if (self.model.role.integerValue == 0) {
        self.volunteer_role = volunteerRoleTypeTeamMember;
        [MHVolunteerUserInfo sharedInstance].volunteer_role = @0;
    } else if (self.model.role.integerValue == 1 && ![self.model.is_promise_approve isEqualToNumber:@1]) {
        [MHVolunteerUserInfo sharedInstance].volunteer_role = @1;
        self.volunteer_role = volunteerRoleTypeCaptain;
    } else if (self.model.role.integerValue == 1 && [self.model.is_promise_approve isEqualToNumber:@1]) {
        [MHVolunteerUserInfo sharedInstance].volunteer_role = @1;
        self.volunteer_role = volunteerRoleTypeCaptain;
    }else if (self.model.role.integerValue == 2) {
        [MHVolunteerUserInfo sharedInstance].volunteer_role = @2;
        self.volunteer_role = volunteerRoleTypeVirtualAccount;
    } else if (self.model.role.integerValue == 9) {
        [MHVolunteerUserInfo sharedInstance].volunteer_role = @9;
        self.volunteer_role = volunteerRoleTypeLeader;
    }
    
    [self.dataSoure removeAllObjects];
    
    [self.dataSoure addObjectsFromArray:[MHVolSerPageFuncConstruct volSerPageFuncConstructWithMainModel:model]];
    //补齐成为3的倍数
    if(self.dataSoure.count % 3){
        NSInteger num = 3 - self.dataSoure.count % 3;
        for(int i=0;i<num;i++){
            MHVoServerFunctiomModel *tempModel = [MHVoServerFunctiomModel new];
            [self.dataSoure addObject:tempModel];
        }
    }
    
    [self.refreshSubject sendNext:nil];
    
    
}
- (RACCommand *)serverCommand{
    if(!_serverCommand){
        @weakify(self);
        _serverCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if(self.dataSoure.count == 0 || [input boolValue]){
                    [MHHUDManager show];
                }
                [[MHNetworking shareNetworking] post:@"volunteer/service/main" params:nil success:^(id data) {
                    [MHHUDManager dismiss];
                    [MHUserInfoManager sharedManager].serve_community_id = data[@"serve_community_id"];
                    [MHUserInfoManager sharedManager].serve_community_name = data[@"serve_community_name"];
                    [[MHUserInfoManager sharedManager] saveUserInfoData];
                    MHVolunteerServiceMainModel *model = [MHVolunteerServiceMainModel yy_modelWithDictionary:data];
                    //缓存
                    NSString *key = [NSString stringWithFormat:@"serviceMainData--%@",[MHUserInfoManager sharedManager].user_id];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
                    
                    [self loadDataWithModel:model];
                    
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    //取缓存
                    NSString *key = [NSString stringWithFormat:@"serviceMainData--%@",[MHUserInfoManager sharedManager].user_id];
                    NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
                    
                    if (data) {
                        MHVolunteerServiceMainModel *model = [MHVolunteerServiceMainModel yy_modelWithDictionary:data];
                        [self loadDataWithModel:model];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    } else {
                        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                        [subscriber sendError:error];
                        [subscriber sendCompleted];
                    }
                    
                    
                }];
                return nil;
            }];
        }];
    }
    return _serverCommand;
}
- (RACCommand *)virtualAccountCommand{
    if(!_virtualAccountCommand){
        MHWeakify(self)
        _virtualAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                MHStrongify(self)
                
                [MHHUDManager show];
                NSMutableDictionary *mut_dic = [NSMutableDictionary dictionary];
                mut_dic[@"volunteer_id"] = input;
                mut_dic[@"register_id"] = [JPUSHService registrationID];
                [[MHNetworking shareNetworking] get:@"volunteer/switch" params:mut_dic success:^(id data) {

                    [MHVolunteerUserInfo sharedInstance].volunteer_id = @([input integerValue]);
                    
                    [self setJpushAliasWithType:MHJPushAliasType_Set vol_id:@([input integerValue])]; //设置新推送别名、只针对特定志愿者做推送
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
        }];
    }
    return _virtualAccountCommand;
}

- (void)setJpushAliasWithType:(MHJPushAliasType)type vol_id:(NSNumber *)vol_id{
    [MHHUDManager show];
#pragma mark - set jpush alias
    // 注册jpush别名
    [MHJPushRequestHandle  mhJpush_AliasWithType:type volunteer_id:vol_id completion:^(BOOL success) {
        [self getOffLine];// 告诉后台发送消息推送
        [MHHUDManager dismiss];
        
    } failure:^(NSString *errmsg) {
#if DEBUG
        [MHHUDManager dismiss];
        [MHHUDManager showText:errmsg];
#endif
    }];

}

- (void)getOffLine {
    [MHHUDManager show];
    // 通知后台把对应的别名设备，发送暂存的通知队列
    [MHJPushRequestHandle mhJpush_getOffLineWithCompletion:^(BOOL success) {
        
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showText:errmsg];
        
    }];
}


- (RACCommand *)attendanceRecordCommand{
    if(!_attendanceRecordCommand){
        _attendanceRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                [[MHNetworking shareNetworking] post:@"volunteer/attendance/records/team/list" params:nil success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:data];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
        }];
    }
    return _attendanceRecordCommand;
}
- (RACSubject *)refreshSubject{
    if(!_refreshSubject){
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (NSMutableArray *)dataSoure{
    if(!_dataSoure){
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

@end
