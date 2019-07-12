//
//  MHQRCodeViewModel.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHQRCodeViewModel.h"
#import "MHNetworking.h"
#import "MHHUDManager.h"
#import "MHConstSDKConfig.h"
#import "MHUserInfoManager.h"
#import "MHStoreCommodityParameter.h"

@interface MHQRCodeViewModel()
//订单消费，订单详情
@property (nonatomic,strong,readwrite)RACCommand *orderDetailCommand;
//订单消费
@property (nonatomic,strong,readwrite)RACCommand *orderCostCommand;

@end

@implementation MHQRCodeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bridgeDataViewModel];
    }
    return self;
}

- (void)bridgeDataViewModel {
    @weakify(self);
    [self.analyticQRCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        @strongify(self);
        if ([isSuccess boolValue]) {
            [MHHUDManager dismiss];
            NSLog(@"扫描二维码成功请求接口返回的数据:%@",datas);
            [self.compleSubject sendNext:datas];
        }else {
            [self.showHUDSubject sendNext:@0];
            [MHHUDManager showErrorText:datas];
            
        }
    }];
    
    [self.analyticQRCodeCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isRequesting = [x boolValue];
    }];
    
    [self.orderDetailCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        @strongify(self);
        if ([isSuccess boolValue]) {
            [MHHUDManager dismiss];
            NSLog(@"扫描二维码成功请求接口返回的数据:%@",datas);
            [self.compleSubject sendNext:datas];
        }else {
            [self.showHUDSubject sendNext:@0];
            [MHHUDManager showErrorText:datas];
            
        }
    }];
    
    [self.orderDetailCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isRequesting = [x boolValue];
    }];
    
    [self.orderCostCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isRequesting = [x boolValue];
    }];
}

//分析扫码出来的字符串,并自动给当前qrcodeType 赋值
- (NSString *)analyticQrcodeStringValue:(NSString *)qrcodeString{
    self.qrcodeType = MHQrcode_scanTypeNone;
    if(!qrcodeString || qrcodeString.length == 0){
        return nil;
    }
    NSString *baseQrcodeStr = [NSString stringWithFormat:@"%@%@",baseUrl,@"qr-code/"];
    //不是我们的网址
    if(![qrcodeString hasPrefix:baseQrcodeStr]){
        return nil;
    }
    NSString *lastStr = [qrcodeString substringFromIndex:baseQrcodeStr.length];
    if(!lastStr || lastStr.length == 0){
        return nil;
    }
    NSArray *arr = [lastStr componentsSeparatedByString:@"/"];
    if(arr.count >= 2){
        NSString *typeStr = [arr firstObject];
        NSString *qrcodeValue = [self qrcodeValueStrWithStrType:typeStr qrcodeLastStr:lastStr];
        return qrcodeValue;
    }else{
        return nil;
    }
    return nil;
}

- (NSString *)qrcodeValueStrWithStrType:(NSString *)strType qrcodeLastStr:(NSString *)qrcodeLastStr{
    MHQrcodeScanType atype = MHQrcode_scanTypeNone;
    NSString *qrcodeValue ;
    if(!strType || strType.length == 0){
        atype = MHQrcode_scanTypeNone;
    }
    if([strType isEqualToString:@"vem"]){
        atype = MHQrcode_scanTypeVem;
        qrcodeValue = [qrcodeLastStr substringFromIndex:strType.length+1];
    }else if([strType isEqualToString:@"seller"]){
        atype = MHQrcode_scanTypeSeller;
        qrcodeValue = [qrcodeLastStr substringFromIndex:strType.length+1];
    }else if([strType isEqualToString:@"score"]){
        
        atype = MHQrcode_scanTypeScore;
        qrcodeValue = [qrcodeLastStr substringFromIndex:strType.length+1];
        
        
    }else if([strType isEqualToString:@"coupon-order"]){
        
        atype = MHQrcode_scanTypeCouponOrder;
        qrcodeValue = [qrcodeLastStr substringFromIndex:strType.length+1];
        
        
    }
    self.qrcodeType = atype;
    return qrcodeValue;
}

- (BOOL)checkScanLimit{
    BOOL isEnable = YES;
    //如果是订单消费二维码
    if(self.qrcodeType == MHQrcode_scanTypeCouponOrder){
        //商家才可以扫并且是从订单消费进去的才可以
        if([MHUserInfoManager sharedManager].is_merchant.integerValue && self.type == MHQRCodeType_OrderCo){
            isEnable = YES;
        }else{
            isEnable = NO;
        }
    }else if(self.qrcodeType == MHQrcode_scanTypeScore){//积分二维码
        //商家才可以扫并且是从扫码收款进去的才可以
        if([MHUserInfoManager sharedManager].is_merchant.integerValue && self.type == MHQRCodeType_Collection){
            isEnable = YES;
        }else{
            isEnable = NO;
        }
    }
    //如果是扫的商家收款码或者自助售买机，但这时候是从订单消费或者从扫码收款进来，则失效
    if((self.qrcodeType == MHQrcode_scanTypeSeller || self.qrcodeType == MHQrcode_scanTypeVem) && (self.type == MHQRCodeType_OrderCo || self.type == MHQRCodeType_Collection)){
        isEnable = NO;
    }
    if(!isEnable){
        self.qrcodeType = MHQrcode_scanTypeNone;
    }
    return isEnable;
}

- (RACCommand *)analyticQRCodeCommand {
    if (!_analyticQRCodeCommand) {
        _analyticQRCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //这个不需要查询了，直接付款
                 if(self.qrcodeType == MHQrcode_scanTypeScore){
                    [subscriber sendNext:RACTuplePack(@1,@{@"qr_code":input})];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                    return nil;
                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:input forKey:@"qr_code"];
                [[MHNetworking shareNetworking] post:@"qr-code/get" params:dic success:^(id data) {
                    [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _analyticQRCodeCommand;
}

//订单消费，订单详情
- (RACCommand *)orderDetailCommand{
    if(!_orderDetailCommand){
        _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *parameter = [MHStoreCommodityParameter orderDetailWithOrder_no:input];
                [[MHNetworking shareNetworking] post:API_mall_merchant_order_detail params:parameter success:^(id data) {
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        /*
                         order_no  string 订单号  nickname  string 下单用户昵称  phone string 下单用户手机  order_status integer
                         订单状态，0待付款，1待使用，2待评价，3已完成，4退款中，5退款成功，6退款失败(待使用)，7已过期 */
                        [subscriber sendNext:RACTuplePack(@1,data)];//元组（是否成功，数据模型）
                        [subscriber sendCompleted];
                        
                    }else{
                        [subscriber sendNext:RACTuplePack(@0,nil)];//元组（是否成功，数据模型）
                        [subscriber sendCompleted];
                    }
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [subscriber sendNext:RACTuplePack(@0,errmsg)];//元组（是否成功，数据模型）
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _orderDetailCommand;
}

//订单消费
- (RACCommand *)orderCostCommand{
    if(!_orderCostCommand){
        @weakify(self);
        _orderCostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter orderCossumeWithOrder_no:self.order_no];
                [[MHNetworking shareNetworking] post:API_mall_merchant_order_consume params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    NSString *errorStr = (errmsg && errmsg.length)?errmsg:@"网络错误";
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errorStr}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _orderCostCommand;
}

- (RACSubject *)showHUDSubject {
    if (!_showHUDSubject) {
        _showHUDSubject = [RACSubject subject];
    }
    return _showHUDSubject;
}
- (RACSubject *)compleSubject {
    if (!_compleSubject) {
        _compleSubject = [RACSubject subject];
    }
    return _compleSubject;
}

@end
