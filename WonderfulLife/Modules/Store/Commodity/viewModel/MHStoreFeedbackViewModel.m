//
//  MHStoreFeedbackViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreFeedbackViewModel.h"
#import "MHStoreCommodityParameter.h"

@interface MHStoreFeedbackViewModel()
//拒绝退款
@property (nonatomic,strong,readwrite)RACCommand *refundCommand;

//反馈意见
@property (nonatomic,strong,readwrite)RACCommand *feedbackCommand;

@end

@implementation MHStoreFeedbackViewModel

#pragma mark - lazyLoad
//拒绝退款
- (RACCommand *)refundCommand{
    if(!_refundCommand){
        @weakify(self);
        _refundCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter merchantRefundWithRefund_id:self.refund_id refuse_reason:self.reason];
                [[MHNetworking shareNetworking] post:API_mall_merchant_refund_refuse params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                
                return nil;
            }];
        }];
    }
    return _refundCommand;
}
//反馈意见
- (RACCommand *)feedbackCommand{
    if(!_feedbackCommand){
        @weakify(self);
        _feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter merchantFeedbackWithMerchant_id:self.merchant_id content:self.reason];
                [[MHNetworking shareNetworking] post:API_mall_merchant_feedback params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                
                return nil;
            }];
        }];
    }
    return _feedbackCommand;
}

@end
