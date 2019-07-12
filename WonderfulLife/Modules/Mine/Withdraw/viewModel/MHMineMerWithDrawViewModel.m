//
//  MHMineMerWithDrawViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithDrawViewModel.h"
#import "MHMineMerWithDrawParameter.h"


@interface MHMineMerWithDrawViewModel()
//提现模块-主页
@property (nonatomic,strong,readwrite)RACCommand *widthDrawMainCommand;

//申请提现
@property (nonatomic,strong,readwrite)RACCommand *applyWidthDraCommand;


@end

@implementation MHMineMerWithDrawViewModel

//提现模块-主页
- (RACCommand *)widthDrawMainCommand{
    if(!_widthDrawMainCommand){
        @weakify(self);
        _widthDrawMainCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHMineMerWithDrawParameter merchantWithDrawMain];
                [[MHNetworking shareNetworking] post:API_mall_merchant_withdraw_main params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [self checkDataWithClass:[NSDictionary class] data:data subscriber:subscriber]){
                        self.refreshFlag = NO;
                        self.withDrawModel = [MHMinMerWithdrawMainModel yy_modelWithJSON:data];
                        [subscriber sendNext:self.withDrawModel];
                        [subscriber sendCompleted];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _widthDrawMainCommand;
}

//申请提现
- (RACCommand *)applyWidthDraCommand{
    if(!_applyWidthDraCommand){
        @weakify(self);
        _applyWidthDraCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHMineMerWithDrawParameter merchantApplyWithDraw];
                [[MHNetworking shareNetworking] post:API_mall_merchant_withdraw_apply params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [self checkDataWithClass:[NSDictionary class] data:data subscriber:subscriber]){
                        self.withdraw_no = data[@"withdraw_no"];
                        [subscriber sendNext:data];
                        [subscriber sendCompleted];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _applyWidthDraCommand;
}

@end
