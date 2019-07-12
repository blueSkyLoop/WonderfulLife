//
//  LPayPasswordFind.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPayPasswordFind.h"
#import "MHNetworking.h"
#import "LHttpParameter.h"
#import "MHHUDManager.h"

@interface LPayPasswordFind()

@property (nonatomic,strong,readwrite)RACCommand *codeGetCommand;
@property (nonatomic,strong,readwrite)RACCommand *codeValiteCommand;

@end

@implementation LPayPasswordFind

- (RACCommand *)codeGetCommand{
    if(!_codeGetCommand){
        _codeGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                NSDictionary *dict = [LHttpParameter forgetPasswordSmsCodeWithToken:@"" phone:input];
                [[MHNetworking shareNetworking] post:API_ForgetPasswordSmsCode_get params:dict success:^(id data) {
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
    return _codeGetCommand;
}


- (RACCommand *)codeValiteCommand{
    if(!_codeValiteCommand){
        _codeValiteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *inputDict) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [MHHUDManager show];
                NSDictionary *dict = [LHttpParameter forgetPasswordSmsCodeValidateWithToken:@"" phone:inputDict[@"phone"] sms_code:inputDict[@"sms_code"]];
                [[MHNetworking shareNetworking] post:API_ForgetPasswordSmsCode_Validate params:dict success:^(id data) {
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
    return _codeValiteCommand;
}


@end
