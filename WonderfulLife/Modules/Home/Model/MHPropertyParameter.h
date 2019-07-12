//
//  MHPropertyParameter.h
//  WonderfulLife
//
//  Created by lgh on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

//查询可抵扣积分
static NSString *const API_property_available = @"payment/property-fee/available";

//物业缴费-支付宝支付
static NSString *const API_property_alipay = @"payment/property-fee/ali/order/create";

//物业缴费-积分+微信支
static NSString *const API_property_wechat = @"payment/property-fee/weixin/order/create";

// 买家-支付宝/微信+积分支付订单
static NSString *const API_coupon_pay = @"payment/mall/coupon/pay";

//买家-查询可抵用积分
static NSString *const API_coupon_available = @"payment/mall/coupon/available";

@interface MHPropertyParameter : NSObject

//查询可抵扣积分
+ (NSDictionary *)queryPropertyAvailableWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list;

//物业缴费-支付宝支付
//score 抵扣积分数,不填或填0代表不使用积分支付
+ (NSDictionary *)alipayWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list score:(NSString *)score pay_password:(NSString *)pay_password;

//物业缴费-积分+微信支
//score 抵扣积分数,不填或填0代表不使用积分支付
+ (NSDictionary *)wechatPayWithProperty_id:(NSString *)property_id payment_month_list:(NSString *)payment_month_list score:(NSString *)score pay_password:(NSString *)pay_password;

// 买家-支付宝/微信+积分支付订单
//score 抵扣的积分数额,不传或传0则不使用积分支付  pay_way  1-支付宝,2-微信 (混合支付或第三方支付必填)
+ (NSDictionary *)couponPayWithOrder_no_list:(NSString *)order_no_list score:(NSString *)score pay_password:(NSString *)pay_password pay_way:(NSInteger)pay_way;

//买家-查询可抵用积分
+ (NSDictionary *)queryCouponAvailableWithOrder_no_list:(NSString *)order_no_list;

@end
