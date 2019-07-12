//
//  MHReportRepairListViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListViewModel.h"
#import "MHNetworking.h"
#import "YYModel.h"

#import "MHHUDManager.h"

#import "MHReportRepairListModel.h"

@interface MHReportRepairListViewModel ()

@property (nonatomic,strong,readwrite)RACSubject *UIRefreshSubject;
@property (nonatomic,strong,readwrite)RACCommand *reportListCommand;
@property (nonatomic,strong,readwrite)RACCommand *reportListCancelCommand;
@property (nonatomic,strong,readwrite)RACCommand *reportListSolveCommand;
@property (nonatomic,strong,readwrite)RACCommand *reportListEvaluateCommand;

@end

@implementation MHReportRepairListViewModel

- (BOOL)isExsitObjectWithRepairment_id:(NSInteger)repairment_id{
    BOOL exsit = NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"repairment_id == %ld",repairment_id];
    NSArray *arr = [self.dataArr filteredArrayUsingPredicate:predicate];
    exsit = arr.count?YES:NO;
    return exsit;
}

#pragma mark - lazyload
//列表请求
- (RACCommand *)reportListCommand{
    if(!_reportListCommand){
        @weakify(self);
        _reportListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *isRefresh) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                if([isRefresh boolValue]){
                    self.page = 1;
                }else{
                    self.page ++;
                }

                NSDictionary *parameter = @{@"status":@(self.type),@"page":@(self.page)};
                [[MHNetworking shareNetworking] post:@"repair/list" params:parameter success:^(id data) {
                    if([data isKindOfClass:[NSDictionary class]]){
                        self.has_next = [data[@"has_next"] boolValue];
                        self.total_pages = [data[@"total_pages"] integerValue];
                        if([isRefresh boolValue]){
                            [self.dataArr removeAllObjects];
                        }
                        NSArray *arr = [NSArray yy_modelArrayWithClass:MHReportRepairListModel.class json:data[@"list"]];
                        [self.dataArr addObjectsFromArray:arr];
                        [self.UIRefreshSubject sendNext:nil];
                        [subscriber sendNext:@(self.has_next)];
                        [subscriber sendCompleted];
                    }else{
                        if(self.page > 1){
                            //还原page回去,不然再拉page就要跳页了
                            self.page --;
                        }
                        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":@"网络出错"}];
                        [subscriber sendError:error];
                        [subscriber sendCompleted];
                    }
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    if(self.page > 1){
                        //还原page回去,不然再拉page就要跳页了
                        self.page --;
                    }
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _reportListCommand;
}

//取消投诉报修
- (RACCommand *)reportListCancelCommand{
    if(!_reportListCancelCommand){
        _reportListCancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *repairment_id) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                [[MHNetworking shareNetworking] post:@"repair/cancel" params:@{@"repairment_id":repairment_id} success:^(id data) {
                    [MHHUDManager dismiss];
                    if([data isKindOfClass:[NSDictionary class]]){
                        NSInteger is_success = [data[@"is_success"] integerValue];
                        if(is_success){
                            [subscriber sendNext:@"取消成功"];
                            [subscriber sendCompleted];
                        }else{
                            NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":@"取消失败"}];
                            [subscriber sendError:error];
                            [subscriber sendCompleted];
                        }
                    }else{
                        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":@"网络出错"}];
                        [subscriber sendError:error];
                        [subscriber sendCompleted];
                    }
                    
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
    return _reportListCancelCommand;
}

//仍未解决
- (RACCommand *)reportListSolveCommand{
    if(!_reportListSolveCommand){
        _reportListSolveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *parameter) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                [[MHNetworking shareNetworking] post:@"repair/activate" params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
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
    return _reportListSolveCommand;
}

//评价
- (RACCommand *)reportListEvaluateCommand{
    if(!_reportListEvaluateCommand){
        _reportListEvaluateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *parameter) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                [[MHNetworking shareNetworking] post:@"repair/evaluate" params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
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
    return _reportListEvaluateCommand;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (RACSubject *)UIRefreshSubject{
    if(!_UIRefreshSubject){
        _UIRefreshSubject = [RACSubject subject];
    }
    return _UIRefreshSubject;
}

@end
