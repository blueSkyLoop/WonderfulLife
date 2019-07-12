//
//  LPayPasswordValidate.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPayPasswordValidate.h"
#import "MHNetworking.h"
#import "LHttpParameter.h"
#import "MHHUDManager.h"

@interface LPayPasswordValidate()
@property (nonatomic,strong,readwrite)RACCommand *payPasswordValidateCommand;
@end

@implementation LPayPasswordValidate

- (RACCommand *)payPasswordValidateCommand{
    if(!_payPasswordValidateCommand){
        _payPasswordValidateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                NSDictionary *dict = [LHttpParameter validatePayWithToken:@"" pay_password:input];
                [[MHNetworking shareNetworking] post:API_ValidatePayPassword params:dict success:^(id data) {
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
    return _payPasswordValidateCommand;
}

@end
