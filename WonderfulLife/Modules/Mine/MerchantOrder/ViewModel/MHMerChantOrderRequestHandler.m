//
//  MHMerChantOrderRequestHandler.m
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerChantOrderRequestHandler.h"
#import "MHNetworking.h"
#import "MHMerchantOrderModel.h"
#import "MHMerchantOrderDetailModel.h"
#import "YYModel.h"

#import "MHStoreGoodsHandler.h"

@implementation MHMerChantOrderRequestHandler


+ (RACSignal *)pullNormalListSignal:(id)input{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_status"] = input;
        [[MHNetworking shareNetworking] post:@"mall/buyer/coupon/order/list" params:input success:^(id data) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MHMerchantOrderModel class] json:data[@"order_list"][@"list"]];
            [subscriber sendNext:RACTuplePack(@1,data[@"order_list"][@"has_next"],array)];//元组（是否成功，是否有下一页，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullManagerListSignal:(id )input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[MHNetworking shareNetworking] post:@"mall/merchant_order/order_list" params:input success:^(id data) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MHMerchantOrderModel class] json:data[@"list"]];
            [subscriber sendNext:RACTuplePack(@1,data[@"has_next"],array)];//元组（是否成功，是否有下一页，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullRefundDoingListSignal:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[MHNetworking shareNetworking] post:@"mall/merchant/refund/list" params:input success:^(id data) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[MHMerchantOrderModel class] json:data[@"refund_list"][@"list"]];
            [subscriber sendNext:RACTuplePack(@1,data[@"refund_list"][@"has_next"],array)];//元组（是否成功，是否有下一页，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullOrderDetailSignal:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_no"] = input;
        if ([MHStoreGoodsHandler shareManager].current_gps_lng&&[MHStoreGoodsHandler shareManager].current_gps_lat) {
            params[@"gps_lng"] = @([MHStoreGoodsHandler shareManager].current_gps_lng);
            params[@"gps_lat"] = @([MHStoreGoodsHandler shareManager].current_gps_lat);
        }
        [[MHNetworking shareNetworking] post:@"mall/buyer/coupon/order/get" params:params success:^(id data) {
            MHMerchantOrderDetailModel *model = [MHMerchantOrderDetailModel yy_modelWithJSON:data];
            [subscriber sendNext:RACTuplePack(@1,model)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)pullMerchantOrderDetailSignal:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_no"] = input;
        if ([MHStoreGoodsHandler shareManager].current_gps_lng&&[MHStoreGoodsHandler shareManager].current_gps_lat) {
            params[@"gps_lng"] = @([MHStoreGoodsHandler shareManager].current_gps_lng);
            params[@"gps_lat"] = @([MHStoreGoodsHandler shareManager].current_gps_lat);
        }
        [[MHNetworking shareNetworking] post:@"mall/merchant_order/order_detail" params:params success:^(id data) {
            MHMerchantOrderDetailModel *model = [MHMerchantOrderDetailModel yy_modelWithJSON:data];
            [subscriber sendNext:RACTuplePack(@1,model)];//元组（是否成功，数据模型）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


+ (RACSignal *)deleteSomeOneOrder:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_no"] = (NSArray*)input[0];
        [[MHNetworking shareNetworking] post:@"mall/buyer/coupon/order/delete" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,(NSArray*)input[1])];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)deleteSomeOneMerchantOrder:(id)input{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_no"] = (NSArray*)input[0];
        params[@"merchant_id"] = (NSArray*)input[2];
        [[MHNetworking shareNetworking] post:@"mall/merchant_order/order_delete" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,(NSArray*)input[1])];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


+ (RACSignal *)comfirmRefundOrder:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"refund_id"] = input;
        [[MHNetworking shareNetworking] post:@"mall/merchant/refund/agree" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}




+ (RACSignal *)reviewMerchantOrGoodsOrder:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

        [[MHNetworking shareNetworking] post:@"mall/buyer/coupon/order/delete" params:input success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)postGoodsOrderComment:(id)input {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [[MHNetworking shareNetworking] post:@"mall/order/coupon/comment/add" params:input success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)deleteSomeMerchantRefundOrder:(id)input{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"refund_id"] = (NSArray*)input[0];
        [[MHNetworking shareNetworking] post:@"mall/merchant/refund/delete" params:params success:^(id data) {
            [subscriber sendNext:RACTuplePack(@1,(NSArray*)input[1])];//元组（是否成功，删除数据在数组的下标）
            [subscriber sendCompleted];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，错误信息）
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


@end
