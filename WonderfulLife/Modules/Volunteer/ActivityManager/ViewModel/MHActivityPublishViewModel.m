//
//  MHActivityPublishViewModel.m
//  WonderfulLife
//
//  Created by zz on 15/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityPublishViewModel.h"
#import "MHVolActivityRequestHandler.h"
#import "MHVolActivityListController.h"

#import "MHCalendarController.h"
#import "MHVolActivityModifyAddressController.h"
#import "MHVolActivityModifyContentController.h"

#import "MHVolunteerUserInfo.h"
#import "MHHUDManager.h"
#import "NSObject+isNull.h"

#import "MHActivityTemplateModel.h"
#import "NSDate+MHCalendar.h"

#import "MHConst.h"
#import "MHAlertView.h"

@interface MHActivityPublishViewModel ()
@property (strong,nonatomic)MHActivityTemplateModel *model;
@property (copy,  nonatomic)NSString *date_begin_result;
@property (copy,  nonatomic)NSString *date_end_result;
@end

@implementation MHActivityPublishViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.postDatas = [NSMutableDictionary dictionary];
        [self initCommonDatas];
        [self bindRACEvents];
    }
    return self;
}

- (void)initCommonDatas {
    if (!self.pullDisplayDatasCommand) {
        self.pullDisplayDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSMutableDictionary *post_dic = [NSMutableDictionary dictionary];
            [post_dic setValue:self.vol_team_id forKey:@"team_id"];
            [post_dic setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
            [post_dic setValue:self.activity_template_id forKey:@"action_template_id"];

            return [MHVolActivityRequestHandler pullActivityInfoTemplateWithTeamJson:post_dic];
        }];
    }
    @weakify(self);
    if (!self.updateModifyDatasCommand) {
        self.updateModifyDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            NSMutableDictionary *m_json = [self.model createDictionayFromModelProperties];
            NSArray *postDatas_keys = [self.postDatas allKeys];
            [postDatas_keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [m_json setValue:self.postDatas[obj] forKey:obj];
            }];
            [m_json setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
            [m_json setValue:self.vol_team_id forKey:@"team_id"];
            [m_json removeObjectsForKeys:@[@"score_rule_method",@"title"]];
            return [MHVolActivityRequestHandler commitNewActivityInfoWithVolunteerJson:m_json];
        }];
    }
    
    [self.modifyIntroduceSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        MHVolActivityModifyContentController *controller = [MHVolActivityModifyContentController new];
        controller.contentTitle   = @"活动介绍";
        controller.content = self.activityIntroduce;
        controller.block   = ^(NSString *text) {
            [self.postDatas setValue:text forKey:@"intro"];
            self.activityIntroduce = text;
            [self.reloadDataSubject sendNext:nil];
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.modifyRulesSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        MHVolActivityModifyContentController *controller = [MHVolActivityModifyContentController new];
        controller.contentTitle = @"活动规则";
        controller.content      = self.activityRule;
        controller.block = ^(NSString *text) {
            [self.postDatas setValue:text forKey:@"rule"];
            self.activityRule = text;
            [self.reloadDataSubject sendNext:nil];
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }];
    
    

    [self.modifyPeoplesSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger peoplesNumber = [x integerValue];
        self.modifyPeoples = peoplesNumber;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"活动人数" forKey:@"title"];
        [dic setValue:[NSString stringWithFormat:@"%@",x] forKey:@"content"];
        [self.dataSources replaceObjectAtIndex:1 withObject:dic];
        
        [self.postDatas setValue:x forKey:@"qty"];
    }];
    
    [self.updateModifyDatasCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas,NSNumber *errCode) = x;
        [MHHUDManager dismiss];
        if ([isSuccess boolValue]) {
            [MHHUDManager showText:@"活动发布成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadVolSerActivityListResultToTopNotification object:nil];
            __block NSUInteger count;
            [self.controller.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
                if([controller isKindOfClass:[MHVolActivityListController class]]){
                    count = idx;
                    *stop = YES;
                }
            }];
            
            [self.controller.navigationController popToViewController:self.controller.navigationController.viewControllers[count] animated:YES];
        }else{
            if ([errCode isEqualToNumber:@2001]) {
                [[MHAlertView sharedInstance]showMessageAlertViewTitle:@"不可发布" message:datas sureHandler:^{
                    [[MHAlertView sharedInstance] dismiss];
                }];
            }else {
                [MHHUDManager showErrorText:datas];
            }
        }
    }];

}

//网络请求回调
- (void)bindRACEvents {
    NSArray *itemTitles = @[@"服务队",@"活动人数",@"开始时间",@"结束时间",@"活动地点",@"活动积分",@"活动规则"];
    @weakify(self);
    [self.pullDisplayDatasCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        if ([isSuccess boolValue]) {
            [self.dataSources removeAllObjects];
            MHActivityTemplateModel *model = datas;
            self.model = model;
            self.activityTitle  = !model.title?@"":model.title;
            self.activityRule   = !model.rule?@"":model.rule;
            self.activityIntroduce = !model.intro?@"":model.intro;
            self.modifyPeoples  = [model.qty integerValue];
            
            ///该处因后台与修改活动返回的时间格式不一致，发布模板带秒返回，故在此作长度判断
            NSString *date_begin_pre = !model.date_begin?@"必填":model.date_begin;
            NSString *date_end_pre   = !model.date_end?@"必填":model.date_end;
            
            NSString *date_begin_result = date_begin_pre;
            NSString *date_end_result = date_end_pre;
            
            if (![date_begin_result isEqualToString:@"必填"]) {
                date_begin_result = [date_begin_pre substringToIndex:16];
            }
            if (![date_end_result isEqualToString:@"必填"]) {
                date_end_result = [date_end_pre substringToIndex:16];
            }
            
            self.date_begin_result = date_begin_result;
            self.date_end_result   = date_end_result;
            
            NSString *qty       = [NSString stringWithFormat:@"%@",model.qty];
            NSString *datebegin = date_begin_result;
            NSString *dateend   = date_end_result;
            NSString *addr      = !model.addr?@"必填":model.addr;
            NSString *rule      = !model.rule?@"":model.rule;
            NSString *scorerule = !model.score_rule_method?@"":model.score_rule_method;
            
            NSArray *modelArray = @[self.vol_team_name,qty,datebegin,dateend,addr,scorerule,rule];
            
            [itemTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:obj forKey:@"title"];
                [dic setValue:modelArray[idx] forKey:@"content"];
                [self.dataSources addObject:dic];
            }];
        }else {
            NSArray *modelArray = @[@"",@"0",@"必填",@"必填",@"必填",@"",@""];
            
            [itemTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:obj forKey:@"title"];
                [dic setValue:modelArray[idx] forKey:@"content"];
                [dic setValue:@"0" forKey:@"limitCount"];
                [self.dataSources addObject:dic];
            }];
        }
        
        [self.reloadDataSubject sendNext:nil];
    }];

}

#pragma mark - Public Method

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        return;
    }
    
    NSDictionary *model = self.dataSources[indexPath.row];
    if (indexPath.row == 2) {
        MHCalendarController *controller = [[MHCalendarController alloc] init];
        controller.calendarTitle = @"开始时间";
        controller.inputDate     = model[@"content"];
        controller.resetDate     = self.date_begin_result;
        @weakify(self);
        controller.block = ^(NSString *date) {
            @strongify(self);
            NSDictionary *date_end_model = self.dataSources[3];
            if ([self combineTimeStart:date endtime:date_end_model[@"content"]]) {
                return;
            }
            [self.postDatas setValue:date forKey:@"date_begin"];

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"开始时间" forKey:@"title"];
            [dic setValue:date forKey:@"content"];
            [self.dataSources replaceObjectAtIndex:2 withObject:dic];
            [self.reloadDataSubject sendNext:nil];
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 3){
        MHCalendarController *controller = [[MHCalendarController alloc] init];
        controller.calendarTitle         = @"结束时间";
        controller.inputDate             = model[@"content"];
        controller.resetDate             = self.date_end_result;
        @weakify(self);
        controller.block = ^(NSString *date) {
            @strongify(self);
            NSDictionary *date_begin_model = self.dataSources[2];
            if ([self combineTimeStart:date_begin_model[@"content"] endtime:date]) {
                [self.postDatas removeObjectForKey:@"date_end"];
                return;
            }
            
            [self.postDatas setValue:date forKey:@"date_end"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"结束时间" forKey:@"title"];
            [dic setValue:date forKey:@"content"];
            [self.dataSources replaceObjectAtIndex:3 withObject:dic];
            [self.reloadDataSubject sendNext:nil];
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 4){
        MHVolActivityModifyAddressController *controller = [[MHVolActivityModifyAddressController alloc]init];
        controller.content = model[@"content"];
        @weakify(self);
        controller.block = ^(NSString *address) {
            @strongify(self);
            
            [self.postDatas setValue:address forKey:@"addr"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"活动地点" forKey:@"title"];
            [dic setValue:address forKey:@"content"];
            [self.dataSources replaceObjectAtIndex:4 withObject:dic];
            [self.reloadDataSubject sendNext:nil];
            
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }
    
}

- (BOOL)combineTimeStart:(NSString *)startTime endtime:(NSString *)endTime {
    
    NSDate *date_begin  = [NSDate dateFromStringDate:startTime format:@"yyyy-MM-dd HH:mm"];
    NSDate *date_end    = [NSDate dateFromStringDate:endTime format:@"yyyy-MM-dd HH:mm"];
    NSComparisonResult result = [date_begin compare:date_end];
    if (result != NSOrderedAscending&&date_begin&&date_end) {
        [MHHUDManager showText:@"开始时间不能晚于结束时间"];
        return YES;
    }
    return NO;
}


@end
