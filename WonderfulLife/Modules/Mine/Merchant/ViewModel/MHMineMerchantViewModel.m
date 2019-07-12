//
//  MHMineMerchantViewModel.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantViewModel.h"
#import "MHMineMerchantInfoModel.h"
#import "MHMineMerchantFuncCountruct.h"
#import "MHMineMerchantInfoModel.h"

#import "MHHUDManager.h"
#import "MHNetworking.h"
#import "MHUserInfoManager.h"
#import "YYModel.h"
#import "NSObject+isNull.h"

@interface MHMineMerchantViewModel()

@property (nonatomic,strong,readwrite)RACCommand *serverCommand;

@property (nonatomic,strong,readwrite)RACSubject *refreshSubject;


@end


@implementation MHMineMerchantViewModel

- (void)loadDataWithModel:(MHMineMerchantInfoModel *)infoModel {
    _infoModel = infoModel ;
    [self.dataSoure removeAllObjects];
    
    [self.dataSoure addObjectsFromArray:[MHMineMerchantFuncCountruct merFuncWithSource:infoModel]];
    //补齐成为3的倍数
    if(self.dataSoure.count % 3){
        NSInteger num = 3 - self.dataSoure.count % 3;
        for(int i=0;i<num;i++){
            MHMineMerchantFunctiomModel *tempModel = [MHMineMerchantFunctiomModel new];
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
                    [MHHUDManager show];
                NSDictionary *dic  = [NSObject isNull:input] ? nil : @{@"merchant_id":input} ;
                [[MHNetworking shareNetworking] post:@"mall/merchant/main" params:dic success:^(id data) {
                    [MHHUDManager dismiss];
                    MHMineMerchantInfoModel *model = [MHMineMerchantInfoModel yy_modelWithDictionary:data];
                    [self loadDataWithModel:model];
                    [subscriber sendNext:model];
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
    return _serverCommand;
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
