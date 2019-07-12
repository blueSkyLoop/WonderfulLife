//
//  MHMineMerFinViewModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/11/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinViewModel.h"
#import "MHMineMerFinModel.h"

#import "YYModel.h"
#import "MHNetworking.h"
#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import "MJRefresh.h"
@interface MHMineMerFinViewModel ()


@property (strong,nonatomic,readwrite) RACCommand *serCom;

@property (strong,nonatomic,readwrite) RACSubject *refreshSub;

@end

@implementation MHMineMerFinViewModel


#pragma mark -- Lazy

- (RACCommand *)serCom {
    
    if (_serCom==nil) {
        MHWeakify(self)
        _serCom  = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            MHStrongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dic = (NSDictionary *)input ;

                [[MHNetworking shareNetworking] post:@"mall/merchant/finance/record/list" params:dic success:^(id data) {
                    MHMineMerFinModel * model = [MHMineMerFinModel yy_modelWithJSON:data];
                     if (self.page == 1) [self.dataSource removeAllObjects];
                    if (model.finance_record_list.list.count) { // 不为 0   
                        [self.dataSource addObjectsFromArray:model.finance_record_list.list];
                    }else {
                        if (self.page > 1)self.page -- ;
                    }
                    
                    [self.refreshSub sendNext:RACTuplePack(model,[NSNumber numberWithBool:model.finance_record_list.has_next])];
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错"}];
                    if (self.page >= 1)self.page -- ;
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }return _serCom ;
}

- (RACSubject *)refreshSub{
    if(!_refreshSub){
        _refreshSub = [RACSubject subject];
    }
    return _refreshSub;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
