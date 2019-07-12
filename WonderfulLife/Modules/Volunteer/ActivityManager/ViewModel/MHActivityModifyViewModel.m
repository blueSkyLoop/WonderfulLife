//
//  MHActivityModifyViewModel.m
//  WonderfulLife
//
//  Created by zz on 13/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyViewModel.h"
#import "MHVolActivityRequestHandler.h"

#import "MHCalendarController.h"
#import "MHVolActivityModifyAddressController.h"
#import "MHVolActivityModifyContentController.h"

#import "MHVolunteerUserInfo.h"
#import "MHHUDManager.h"
#import "NSObject+isNull.h"

#import "MHActivityModifyModel.h"
#import "NSDate+MHCalendar.h"
#import "MHConst.h"

@interface MHActivityModifyViewModel ()
@property (strong,nonatomic)MHActivityModifyModel *model;
@end

@implementation MHActivityModifyViewModel

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
            return [MHVolActivityRequestHandler pullActivityModifyInfoWithId:RACTuplePack(self.activity_team_id,self.action_id)];
        }];
    }

    if (!self.updateModifyDatasCommand) {
        @weakify(self);
        self.updateModifyDatasCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            NSMutableDictionary *m_json = [self.model createDictionayFromModelProperties];
            NSArray *postDatas_keys = [self.postDatas allKeys];
            [postDatas_keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [m_json setValue:self.postDatas[obj] forKey:obj];
            }];
            [m_json removeObjectForKey:@"score_rule_method"];
            [m_json removeObjectForKey:@"action_type"];
            [m_json removeObjectForKey:@"team_name"];
            [m_json removeObjectForKey:@"title"];
            [m_json removeObjectForKey:@"team_id"];
            [m_json removeObjectForKey:@"yty"];
            [m_json setValue:[MHVolunteerUserInfo sharedInstance].volunteer_id forKey:@"volunteer_id"];
            return [MHVolActivityRequestHandler updateActivityModifyInfoWithJson:m_json];
        }];
    }

}

- (void)bindRACEvents {
    
    NSArray *itemTitles = @[@"服务队",@"活动人数",@"开始时间",@"结束时间",@"活动地点",@"活动积分",@"活动规则"];
    
    @weakify(self);
    [self.pullDisplayDatasCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        if ([isSuccess boolValue]) {
            MHActivityModifyModel *model = datas;
            self.activityTitle  = !model.title?@"":model.title;
            self.activityRule   = !model.rule?@"":model.rule;
            self.activityIntroduce = !model.intro?@"":model.intro;

            NSString *teamname  = !model.team_name?@"":model.team_name;
            NSString *qty       = [NSString stringWithFormat:@"%@",model.qty];
            if ([NSObject isNull:model.qty]) {
                qty = @"0";
                model.qty = @0;
            }
            NSString *yty       = [NSString stringWithFormat:@"%@",model.yty];
            if ([NSObject isNull:model.yty]) {
                yty = @"0";
                model.yty = @0;
            }
            NSString *datebegin = !model.date_begin?@"必填":model.date_begin;
            NSString *dateend   = !model.date_end?@"必填":model.date_end;
            NSString *addr      = !model.addr?@"必填":model.addr;
            NSString *rule      = !model.rule?@"":model.rule;
            NSString *scorerule = !model.score_rule_method?@"":model.score_rule_method;

            self.model = model;
            
            NSArray *modelArray = @[teamname,qty,datebegin,dateend,addr,scorerule,rule];
            
            [itemTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:obj forKey:@"title"];
                [dic setValue:modelArray[idx] forKey:@"content"];
                [dic setValue:yty forKey:@"limitCount"];
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

    [self.modifyIntroduceSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        MHVolActivityModifyContentController *controller = [MHVolActivityModifyContentController new];
        controller.contentTitle   = @"活动介绍";
        controller.content = self.activityIntroduce;
        controller.block   = ^(NSString *text) {
            if ([text isEqualToString:self.model.intro]) {
                [self.postDatas removeObjectForKey:@"intro"];
                return;
            }
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
            if ([text isEqualToString: self.model.rule]) {
                [self.postDatas removeObjectForKey:@"rule"];
                return;
            }
            [self.postDatas setValue:text forKey:@"rule"];
            self.activityRule = text;
            [self.reloadDataSubject sendNext:nil];
        };
        [self.controller.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.modifyPeoplesSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger peoplesNumber = [x integerValue];
        if (peoplesNumber == [self.model.qty integerValue]) {
            [self.postDatas removeObjectForKey:@"qty"];
            return;
        }
        [self.postDatas setValue:x forKey:@"qty"];
    }];
    
    // 提交修改活动的资料，返回上一个界面
    [self.updateModifyDatasCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        [MHHUDManager dismiss];
        if ([isSuccess boolValue]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kReloadVolSerActivityListResultNotification object:nil];
            [self.controller.navigationController popViewControllerAnimated:YES];
            [MHHUDManager showText:@"活动修改成功"];
        }else{
            [MHHUDManager showErrorText:datas];
        }
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
        controller.inputDate = model[@"content"];
        controller.resetDate = self.model.date_begin;
        @weakify(self);
        controller.block = ^(NSString *date) {
            @strongify(self);
            NSDictionary *date_end_model = self.dataSources[3];
            if ([self combineTimeStart:date endtime:date_end_model[@"content"]]) {
                return;
            }
            
            if ([date isEqualToString: self.model.date_begin]) {
                [self.postDatas removeObjectForKey:@"date_begin"];
                return ;
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
        controller.resetDate             = self.model.date_end;
        @weakify(self);
        controller.block = ^(NSString *date) {
            @strongify(self);
            NSDictionary *date_begin_model = self.dataSources[2];
            if ([self combineTimeStart:date_begin_model[@"content"] endtime:date]) {
                return;
            }
            
            if ([date isEqualToString: self.model.date_end]) {
                [self.postDatas removeObjectForKey:@"date_end"];
                return ;
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
            if ([address isEqualToString: self.model.addr]) {
                [self.postDatas removeObjectForKey:@"addr"];
                return ;
            }
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
