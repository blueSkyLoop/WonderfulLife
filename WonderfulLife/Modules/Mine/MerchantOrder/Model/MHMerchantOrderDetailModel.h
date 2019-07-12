//
//  MHMerchantOrderDetailModel.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMerchantOrderDetailModel : NSObject
/**
 订单号
 */
@property (nonatomic,  copy) NSString *order_no;
/**
 订单状态，如待付款、待使用
 */
@property (nonatomic,  copy) NSString *order_status;
/**
 商品名称
 */
@property (nonatomic,  copy) NSString *coupon_name;
/**
 商品价格
 */
@property (nonatomic,  copy) NSString *coupon_price;
/**
 商家名称
 */
@property (nonatomic,  copy) NSString *merchant_name;
/**
 商品门市价
 */
@property (nonatomic,  copy) NSString *retail_price;
/**
 支付金额
 */
@property (nonatomic,  copy) NSString *pay_amount;
/**
 支付金额(商家)
 */
@property (nonatomic,  copy) NSString *order_price;
/**
 支付方式
 */
@property (nonatomic,  copy) NSString *payment_mode;
/**
 有效日期
 */
@property (nonatomic,  copy) NSString *expiry_time;
/**
 下单时间
 */
@property (nonatomic,  copy) NSString *order_time;
/**
 评价商家
 */
@property (nonatomic,strong) NSNumber *grade_to_merchant;
/**
 评价商品
 */
@property (nonatomic,strong) NSNumber *grade_to_goods;
/**
 具体评价内容
 */
@property (nonatomic,  copy) NSString *comment;
/**
 退款申请日期
 */
@property (nonatomic,  copy) NSString *refund_apply_time;
/**
 退款理由
 */
@property (nonatomic,  copy) NSString *refund_reason;
/**
 退款说明
 */
@property (nonatomic,  copy) NSString *refund_remark;
/**
 退款审核说明（拒绝退款的理由）
 */
@property (nonatomic,  copy) NSString *refund_audit_remark;
/**
 商品封面图片
 */
@property (nonatomic,  copy) NSString *coupon_img_cover;
/**
 json array 格式图片：http://172.16.1.50:8080/meihaohui_api/data.html#ImgInfo
 */
@property (nonatomic,strong) NSArray *comment_img_details;
/**
 距离
 */
@property (nonatomic,  copy) NSString *distance;
/**
 销量
 */
@property (nonatomic,  copy) NSString *coupon_sales;
/**
 商家id
 */
@property (nonatomic,strong) NSNumber *merchant_id;
/**
 买家手机号码
 */
@property (nonatomic,  copy) NSString *buyer_phone;
/**
 订单二维码值
 */
@property (nonatomic,  copy) NSString *qr_code;
/**
 订单状态枚举值，0待付款，1待使用，2待评价，3已评价,4退款中，5退款成功，6退款失败
 */
@property (nonatomic,  copy) NSString *order_status_type;
/**
 商家联系电话
 */
@property (nonatomic,  copy) NSString *merchant_phone;
/**
 代金券id
 */
@property (nonatomic,strong) NSNumber *coupon_id;
/**
 退还内容
 */
@property (nonatomic,  copy) NSString *refund_content;
/**
 退还方式
 */
@property (nonatomic,  copy) NSString *refund_way;
/**
 0为正常,1为该小区已关闭商城
 */
@property (nonatomic,  copy) NSString *status;
/**
 实际支付金额
 */
@property (nonatomic, copy) NSString *actual_pay_amount;
/**
 积分抵扣
 */
@property (nonatomic, copy) NSString *pay_score;
/**
 商品类型,0-优惠券,1-商家扫志愿者积分二维码收款,2-志愿者扫商家收款码付款',
 */
@property (nonatomic,strong) NSNumber *goods_type;
/********** 本地处理图片 ************/

@property (nonatomic, strong)NSArray *selectedImages;

@property (nonatomic, strong)NSArray *selectedAsserts;

/********** 商家 ************/

@property(nonatomic,copy) NSString *nickname;
/**
 用户手机
 */
@property(nonatomic,copy) NSString *login_username;
/**
 商品有效期开始时间
 */
@property(nonatomic,copy) NSString *expiry_time_begin;
/**
 商品有效期结束时间
 */
@property(nonatomic,copy) NSString *expiry_time_end;
/**
 销量
 */
@property(nonatomic,strong) NSNumber *sales;
/**
 退款申请审核操作日期
 */
@property(nonatomic,copy) NSString *refund_audit_time;
/**
 退款id
 */
@property(nonatomic,copy) NSNumber *refund_id;
/**
 下单时间(商家中的字段)
 */
@property (nonatomic,  copy) NSString *create_datetime;
/**
 商品封面图片(商家中的字段)
 */
@property (nonatomic,  copy) NSString *img_cover;
/**
 json array 格式图片：http://172.16.1.50:8080/meihaohui_api/data.html#ImgInfo (商家)
 */
@property (nonatomic,strong) NSArray *comment_imgs;
@end
