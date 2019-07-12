//
//  LIntegralsGoodsModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIntegralsGoodsModel : NSObject

@property (nonatomic,copy)NSString * score_need_pay;                    //需要支付的积分
@property (nonatomic,copy)NSString * goods_name;                        //商品名称
@property (nonatomic,assign)NSInteger qty;                              //商品数量
@property (nonatomic,copy)NSString * payee;                             //收款方
@property (nonatomic,copy)NSString * order_no;                          //订单号
@property (nonatomic,assign)NSInteger payment_id;                       //支付单id
@property (nonatomic,assign)NSInteger is_set_pay_password;              //0|1	是否设置支付密码,0未设置,1已设置
@property (nonatomic,assign)NSInteger enough_to_pay;                    //0|1	积分够不够,0不够,1积分足够
@property (nonatomic,copy)NSString *goods_id;                           //
@property (nonatomic,copy)NSString *amount;                             //
@property (nonatomic,assign)NSInteger is_volunteer;                     //
@property (nonatomic,copy)NSString *vend_code;                           //

@end
