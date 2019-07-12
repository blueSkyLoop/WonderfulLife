//
//  MHStoreCommodityParameter.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreCommodityParameter.h"
#import "YYModel.h"
#import "LCommonModel.h"

@implementation MHStoreCommodityParameter

//商品详情
+ (NSDictionary *)goodsDetailWithCoupon_id:(NSInteger)coupon_id gps_lng:(NSString *)gps_lng gps_lat:(NSString *)gps_lat{
    if(gps_lat && gps_lng){
        return @{
                 @"coupon_id":@(coupon_id),
                 @"gps_lng":gps_lng,
                 @"gps_lat":gps_lat
                 };
    }
    return @{@"coupon_id":@(coupon_id)};
}

//推荐商品列表
+ (NSDictionary *)recommendGoodsListWithCommunity_id:(NSInteger)community_id gps_lng:(NSString *)gps_lng gps_lat:(NSString *)gps_lat page:(NSInteger)page{
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    if(community_id){
        [muDict setValue:@(community_id) forKey:@"community_id"];
    }
    if(gps_lat && gps_lng){
        [muDict setValue:gps_lng forKey:@"gps_lng"];
        [muDict setValue:gps_lat forKey:@"gps_lat"];
    }
    [muDict setValue:@(page) forKey:@"page"];
    
    return muDict;
}

//搜索-商品列表
+ (NSDictionary *)searchGoodsListWithCommunity_id:(NSInteger)community_id longitude:(double)longitude latitude:(double)latitude keyword:(NSString *)keyword page:(NSInteger)page{
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    if(community_id){
        [muDict setValue:@(community_id) forKey:@"community_id"];
    }
    if(longitude && latitude){
        [muDict setValue:@(longitude) forKey:@"longitude"];
        [muDict setValue:@(latitude) forKey:@"latitude"];
    }
    if(keyword){
        [muDict setValue:keyword forKey:@"keyword"];
    }
    [muDict setValue:@(page) forKey:@"page"];
    
    return muDict;

}

//买家-提交订单-下单界面
+ (NSDictionary *)orderSubmitQueryWithCoupon_id:(NSInteger)coupon_id{
    return @{@"coupon_id":@(coupon_id)};
}

//买家-提交订单
+ (NSDictionary *)orderCreateWithCoupon_id:(NSInteger)coupon_id qty:(NSInteger)qty{
    return @{
             @"coupon_id":@(coupon_id),
             @"qty":@(qty)
             };
}

//我是商家-反馈意见
+ (NSDictionary *)merchantFeedbackWithMerchant_id:(NSInteger)merchant_id content:(NSString *)content{
    return @{
             @"merchant_id":@(merchant_id),
             @"content":content
             };
}

//我是商家-处理退款-拒绝退款
+ (NSDictionary *)merchantRefundWithRefund_id:(NSInteger)refund_id refuse_reason:(NSString *)refuse_reason{
    return @{
             @"refund_id":@(refund_id),
             @"refuse_reason":refuse_reason
             };
}

//订单退款理由
+ (NSDictionary *)refundReasonList{
    return @{};
}

//买家-申请退款
+ (NSDictionary *)couponApplyRefundWithOrder_no:(NSString *)order_no reason_id_list:(NSArray *)reason_id_list refund_remark:(NSString *)refund_remark{
    return @{
             @"order_no":order_no,
             @"reason_id_list":[reason_id_list yy_modelToJSONString],
             @"refund_remark":refund_remark
             };
}

//买家-积分支付 type  支付项目类型,周边商家请输入"mall"   data 项目数据,周边商家请传订单号,如果有多个订单号用英文字母逗号隔开 password 加密后的密码
+ (NSDictionary *)paymentScoreWithType:(NSString *)type data:(NSString *)data password:(NSString *)password{
    return @{
             @"type":type,
             @"data":data,
             @"password":[LCommonModel md532BitLowerKey:password]
             };
}
//支付前校验接口
+ (NSDictionary *)paymentScoreCheckWithScore:(NSString *)score{
    return @{@"score":score};
}

//我是商家-订单消费-订单详情
+ (NSDictionary *)orderDetailWithOrder_no:(NSString *)order_no{
    return @{
             @"order_no":order_no
             };
}

//我是商家-订单消费-确定消费
+ (NSDictionary *)orderCossumeWithOrder_no:(NSString *)order_no{
    return @{
             @"order_no":order_no
             };
}

@end
