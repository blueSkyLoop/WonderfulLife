//
//  LPayPasswordSet.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPayPasswordSet.h"
#import "MHNetworking.h"
#import "LHttpParameter.h"
#import "MHHUDManager.h"

@interface LPayPasswordSet()

@property (nonatomic,strong,readwrite)RACCommand *payPasswordCommand;

@end

@implementation LPayPasswordSet

- (RACCommand *)payPasswordCommand{
    if(!_payPasswordCommand){
        _payPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               [MHHUDManager show];
               NSDictionary *dict = [LHttpParameter setPayPasswordWithToken:@"" pay_password:(NSString *)input];
                [[MHNetworking shareNetworking] post:API_SetPayPassword params:dict success:^(id data) {
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
    return _payPasswordCommand;
}

@end
