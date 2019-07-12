//
//  MHPropertyParameter.m
//  WonderfulLife
//
//  Created by lgh on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHPropertyParameter.h"
#import "LCommonModel.h"

@implementation MHPropertyParameter

//查询可抵扣积分
+ (NSDictionary *)queryPropertyAvailableWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list{
    return @{
             @"property_id":property_id,
             @"payment_month_list":payment_month_list
             };
}

//物业缴费-支付宝支付
//score 抵扣积分数,不填或填0代表不使用积分支付
+ (NSDictionary *)alipayWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list score:(NSString *)score pay_password:(NSString *)pay_password{
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setValue:property_id forKey:@"property_id"];
    [muDict setValue:payment_month_list forKey:@"payment_month_list"];
    if(score){
        [muDict setValue:score forKey:@"score"];
    }
    if(pay_password){
        [muDict setValue:[LCommonModel md532BitLowerKey:pay_password] forKey:@"pay_password"];
    }
    return muDict;
}

//物业缴费-积分+微信支
//score 抵扣积分数,不填或填0代表不使用积分支付
+ (NSDictionary *)wechatPayWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list score:(NSString *)score pay_password:(NSString *)pay_password{
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setValue:property_id forKey:@"property_id"];
    [muDict setValue:payment_month_list forKey:@"payment_month_list"];
    if(score){
        [muDict setValue:score forKey:@"score"];
    }
    if(pay_password){
        [muDict setValue:[LCommonModel md532BitLowerKey:pay_password] forKey:@"pay_password"];
    }
    return muDict;
}

// 买家-支付宝/微信+积分支付订单
//score 抵扣的积分数额,不传或传0则不使用积分支付  pay_way  1-支付宝,2-微信 (混合支付或第三方支付必填)
+ (NSDictionary *)couponPayWithOrder_no_list:(NSString *)order_no_list score:(NSString *)score pay_password:(NSString *)pay_password pay_way:(NSInteger)pay_way{
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setValue:order_no_list forKey:@"order_no_list"];
    if(score){
        [muDict setValue:score forKey:@"score"];
    }
    if(pay_password){
        [muDict setValue:[LCommonModel md532BitLowerKey:pay_password] forKey:@"pay_password"];
    }
    [muDict setValue:@(pay_way) forKey:@"pay_way"];
    return muDict;
}

//买家-查询可抵用积分
+ (NSDictionary *)queryCouponAvailableWithOrder_no_list:(NSString *)order_no_list{
    return @{@"order_no_list":order_no_list};
}

@end
