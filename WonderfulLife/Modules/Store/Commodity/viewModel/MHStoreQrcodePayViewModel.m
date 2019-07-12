//
//  MHStoreQrcodePayViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/1.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreQrcodePayViewModel.h"
#import "MHStoreCommodityParameter.h"

@interface MHStoreQrcodePayViewModel()
//确定支付
@property (nonatomic,strong,readwrite)RACCommand *payCommand;

@end

@implementation MHStoreQrcodePayViewModel

#pragma mark -  lazyload
- (RACCommand *)payCommand{
    if(!_payCommand){
        @weakify(self);
        _payCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                
                return nil;
            }];
        }];
    }
    return _payCommand;
}

@end
