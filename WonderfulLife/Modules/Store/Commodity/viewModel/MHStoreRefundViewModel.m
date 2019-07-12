//
//  MHStoreRefundViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundViewModel.h"
#import "MHStoreRefundReasonModel.h"
#import "MHStoreCommodityParameter.h"

@interface MHStoreRefundViewModel()

//订单退款理由
@property (nonatomic,strong,readwrite)RACCommand *refundReasonListCommand;
//买家-申请退款
@property (nonatomic,strong,readwrite)RACCommand *appleRefundCommand;

@end

@implementation MHStoreRefundViewModel

- (void)handleDataWithModel:(NSArray *)reasonList{
    [self.dataSoure removeAllObjects];
    //创建三组数据
    [self.dataSoure addObject:@[self.detailModel]];
    [self.dataSoure addObject:reasonList?:@[]];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setValue:@"" forKey:@"reamrk"];
    [self.dataSoure addObject:@[muDict]];
}

#pragma mark - lazy load
//订单退款理由
- (RACCommand *)refundReasonListCommand{
    if(!_refundReasonListCommand){
        @weakify(self);
        _refundReasonListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter refundReasonList];
                [[MHNetworking shareNetworking] post:API_mall_merchant_refundReason_list params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSArray class]]){
                        NSArray *reasonList = [NSArray yy_modelArrayWithClass:MHStoreRefundReasonModel.class json:data];
                        [self handleDataWithModel:reasonList];
                        [subscriber sendNext:self.detailModel];
                        [subscriber sendCompleted];
                    }else{
                        [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
                    }
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
            
        }];
    }
    return _refundReasonListCommand;
}
//买家-申请退款
- (RACCommand *)appleRefundCommand{
    if(!_appleRefundCommand){
        @weakify(self);
        _appleRefundCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSArray *arr = self.selectReaseArr;
                NSMutableArray *reasonListArr = [NSMutableArray arrayWithCapacity:arr.count];
                for(int i=0;i<arr.count;i++){
                    MHStoreRefundReasonModel *model = arr[i];
                    [reasonListArr addObject:@{@"reason_id":@(model.reason_id)}];
                }
                NSDictionary *parameter = [MHStoreCommodityParameter couponApplyRefundWithOrder_no:self.order_no reason_id_list:reasonListArr refund_remark:self.reamrk];
                [[MHNetworking shareNetworking] post:API_mall_coupon_refund_apply params:parameter success:^(id data) {
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
    return _appleRefundCommand;
}


- (NSArray *)selectReaseArr{
    _selectReaseArr = nil;
    NSArray *arr = self.dataSoure[1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == %@",@(YES)];
    _selectReaseArr =  [arr filteredArrayUsingPredicate:predicate];
    return _selectReaseArr;
}

- (NSString *)reamrk{
    NSArray *arr = self.dataSoure[2];
    NSMutableDictionary *dict = [arr firstObject];
    _reamrk = dict[@"reamrk"];
    return _reamrk;
}

- (BOOL)isChanged{
    NSArray *arr = self.selectReaseArr;
    NSString *remark = self.reamrk;
    if((remark && remark.length) || (arr && arr.count)){
        _isChanged = YES;
    }else{
        _isChanged = NO;
    }
    return _isChanged;
}


@end
