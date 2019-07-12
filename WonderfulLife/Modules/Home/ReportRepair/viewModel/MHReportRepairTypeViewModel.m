//
//  MHReportRepairTypeViewModel.m
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairTypeViewModel.h"
#import "MHNetworking.h"
#import "MHHUDManager.h"
#import "YYModel.h"

@interface MHReportRepairTypeViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *repairTypeCommand;
@property (nonatomic,strong,readwrite)RACCommand *repairTypeSubitemsCommand;
@property (nonatomic,strong) MHReportRepairTypeModel *model;
@end

@implementation MHReportRepairTypeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self bindCommandEvents];
    }
    return self;
}


#pragma mark - Getter
- (RACCommand *)repairTypeCommand {
    if (!_repairTypeCommand) {
        _repairTypeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[MHNetworking shareNetworking] post:@"repair/getOneCategory" params:nil success:^(id data) {
                    NSArray *list = [NSArray yy_modelArrayWithClass:[MHReportRepairTypeModel class] json:data];
                    [subscriber sendNext:list];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _repairTypeCommand;
}

- (RACCommand *)repairTypeSubitemsCommand {
    if (!_repairTypeSubitemsCommand) {
        _repairTypeSubitemsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"repairment_category_id"] = input;
                [[MHNetworking shareNetworking] post:@"repair/getOtherCategory" params:dic success:^(id data) {
                    NSArray *list = [NSArray yy_modelArrayWithClass:[MHReportRepairTypeModel class] json:data];
                    [subscriber sendNext:list];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _repairTypeSubitemsCommand;
}

- (RACSubject *)refreshViewSubject {
    if (!_refreshViewSubject) {
        _refreshViewSubject = [RACSubject subject];
    }
    return _refreshViewSubject;
}

- (MHReportRepairTypeModel*)model {
    if (!_model) {
        _model = [MHReportRepairTypeModel new];
    }
    return _model;
}
@end
