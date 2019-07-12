//
//  MHStoreCommodityParameter.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
//商品详情
static NSString *const API_mall_coupon_get = @"mall/coupon/get";
//推荐商品列表
static NSString *const API_mall_coupon_recommend_list = @"mall/coupon/recommend/list";
//搜索-商品列表
static NSString *const API_mall_coupon_search = @"mall/coupon/search";
//买家-提交订单-下单界面
static NSString *const API_mall_coupon_before_buy = @"mall/coupon/before-buy";
//买家-提交订单
static NSString *const API_mall_order_create = @"mall/order/create";
//我是商家-反馈意见
static NSString *const API_mall_merchant_feedback = @"mall/merchant/feedback";
//我是商家-处理退款-拒绝退款
static NSString *const API_mall_merchant_refund_refuse = @"mall/merchant/refund/refuse";
//订单退款理由
static NSString *const API_mall_merchant_refundReason_list = @"mall/merchant/refundReason/list";
//买家-申请退款
static NSString *const API_mall_coupon_refund_apply = @"mall/coupon/refund/apply";
//买家-积分支付
static NSString *const API_payment_score_pay = @"payment/score/pay";
//支付前校验接口
static NSString *const API_payment_score_check = @"payment/score/check";
//我是商家-订单消费-订单详情
static NSString *const API_mall_merchant_order_detail = @"mall/merchant/order/detail";
//我是商家-订单消费-确定消费
static NSString *const API_mall_merchant_order_consume = @"mall/merchant/order/consume";

@interface MHStoreCommodityParameter : NSObject

//商品详情
+ (NSDictionary *)goodsDetailWithCoupon_id:(NSInteger)coupon_id gps_lng:(NSString *)gps_lng gps_lat:(NSString *)gps_lat;

//推荐商品列表
+ (NSDictionary *)recommendGoodsListWithCommunity_id:(NSInteger)community_id gps_lng:(NSString *)gps_lng gps_lat:(NSString *)gps_lat page:(NSInteger)page;

//搜索-商品列表
+ (NSDictionary *)searchGoodsListWithCommunity_id:(NSInteger)community_id longitude:(double)longitude latitude:(double)latitude keyword:(NSString *)keyword page:(NSInteger)page;

//买家-提交订单-下单界面
+ (NSDictionary *)orderSubmitQueryWithCoupon_id:(NSInteger)coupon_id;

//买家-提交订单
+ (NSDictionary *)orderCreateWithCoupon_id:(NSInteger)coupon_id qty:(NSInteger)qty;

//我是商家-反馈意见
+ (NSDictionary *)merchantFeedbackWithMerchant_id:(NSInteger)merchant_id content:(NSString *)content;

//我是商家-处理退款-拒绝退款
+ (NSDictionary *)merchantRefundWithRefund_id:(NSInteger)refund_id refuse_reason:(NSString *)refuse_reason;

//订单退款理由
+ (NSDictionary *)refundReasonList;

//买家-申请退款  reason_id_list内部已经实现数组转字符串
+ (NSDictionary *)couponApplyRefundWithOrder_no:(NSString *)order_no reason_id_list:(NSArray *)reason_id_list refund_remark:(NSString *)refund_remark;

//买家-积分支付 type  支付项目类型,周边商家请输入"mall"   data 项目数据,周边商家请传订单号,如果有多个订单号用英文字母逗号隔开 password 加密后的密码
+ (NSDictionary *)paymentScoreWithType:(NSString *)type data:(NSString *)data password:(NSString *)password;

//支付前校验接口
+ (NSDictionary *)paymentScoreCheckWithScore:(NSString *)score;

//我是商家-订单消费-订单详情
+ (NSDictionary *)orderDetailWithOrder_no:(NSString *)order_no;

//我是商家-订单消费-确定消费
+ (NSDictionary *)orderCossumeWithOrder_no:(NSString *)order_no;



@end
