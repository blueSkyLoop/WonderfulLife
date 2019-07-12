//
//  MHMerchantOrderModel.h
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMerchantOrderModel : NSObject
/**
 订单号
 */
@property (nonatomic,copy) NSString *order_no;
/**
 优惠券名称
 */
@property (nonatomic,copy) NSString *coupon_name;
/**
 商家名称
 */
@property (nonatomic,copy) NSString *merchant_name;
/**
 订单总价
 */
@property (nonatomic,copy) NSString *order_price;
/**
 有效期时间
 */
@property (nonatomic,copy) NSString *expiry_time;

/**
 优惠券封面图片
 */
@property (nonatomic,copy) NSString *img_cover;
/**
 订单状态,返回字符串
 */
@property (nonatomic,copy) NSString *order_status;
/**
 订单id
 */
@property (nonatomic,strong) NSNumber *order_id;
/**
 二维码值
 */
@property (nonatomic,strong) NSString *qr_code;
/**
 订单状态枚举值，0待付款，1待使用，2待评价，3已评价,4退款中，5退款成功，6退款失败
 */
@property (nonatomic,strong) NSNumber *order_status_type;
/**
 0为正常,1为该小区已关闭商城
 */
@property (nonatomic,  copy) NSString *status;
/**
 商品类型,0-优惠券,1-商家扫志愿者积分二维码收款,2-志愿者扫商家收款码付款',
 */
@property (nonatomic,strong) NSNumber *goods_type;

/********** 商家 ************/
/**
 商家名称
 */
@property (nonatomic,copy) NSString *name;
/**
 商品有效期开始时间
 */
@property (nonatomic,copy) NSString *expiry_time_begin;
/**
 商品有效期结束时间
 */
@property (nonatomic,copy) NSString *expiry_time_end;
/**
 申请退款用户名
 */
@property (nonatomic,copy) NSString *user_nickname;
/**
 订单状态,返回字符串(退款列表用到)
 */
@property (nonatomic,strong) NSNumber *refund_status;
/**
 退款ID
 */
@property (nonatomic,strong) NSNumber *refund_id;
@end
