//
//  MHMineMerchantPayModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/1.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMineMerchantPayModel : NSObject

/** 商家id*/
@property (nonatomic, strong)   NSNumber * merchant_id;


/** 条形码*/
@property (nonatomic, copy)   NSString * bar_code;

/** 二维码*/
@property (nonatomic, copy)   NSString * qr_code;

/** 收款时间*/
@property (nonatomic, copy)   NSString * income_datetime;

/** 收款金额*/
@property (nonatomic, copy)   NSString * income_amount;

/** 收款状态 0:失败   1:成功*/
@property (nonatomic, assign) BOOL income_result;

/** 支付时间*/
@property (nonatomic, copy)   NSString * pay_datetime;


/** 商家名*/
@property (nonatomic, copy)   NSString * merchant_name;

/** 支付的金额*/
@property (nonatomic, copy)   NSString * pay_money;

/** 支付状态 0:失败   1:成功*/
@property (nonatomic, assign) BOOL  pay_result;




@end

/** 
 merchant_id true string 商家id
 amount true string 收款金额
 */
