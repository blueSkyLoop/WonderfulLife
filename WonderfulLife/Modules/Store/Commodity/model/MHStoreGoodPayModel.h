//
//  MHStoreGoodPayModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MHPayType) {
    mhPay_coupon_pay = 1,               //商品支付
    mhPay_qrcode_pay,                   //扫码支付
    mhPay_property_pay                  //物业缴费
};

@interface MHStoreGoodPayModel : NSObject

//自定义的支付商品类型
@property (nonatomic,assign)MHPayType type;
//支付类型
@property (nonatomic,copy)NSString *payTypeStr;
//支付数据，要根据支付类型来给相应的数据
@property (nonatomic,copy)NSString *payData;
//总共要支付的积分，主要用在支付前校验
@property (nonatomic,copy)NSString *totalScore;

//支付成功回传的对象,可传可不传，里面不对这个字段处理，只是作为支付成功通知kStoreOrderPaySuccessNotification发出的一个参数返回给调起者识别，传的话，成功之后会发出通知，并把这个goodsId发出去，否则发通知时不携带这个字段，建议传，外部收到通知时核对这个对象，如果对象与发起的不一致，不作处理，因为别的支付也会发送这个通知
@property (nonatomic,strong)id noticeObject;

@end
