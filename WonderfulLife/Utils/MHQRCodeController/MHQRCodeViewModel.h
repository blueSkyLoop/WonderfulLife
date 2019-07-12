//
//  MHQRCodeViewModel.h
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

typedef NS_ENUM(NSInteger, MHQRCodeType){
    
    /** 订单消费*/
    MHQRCodeType_OrderCo = 1,
    
    /** 扫码收款*/
    MHQRCodeType_Collection
    
};

typedef NS_ENUM(NSInteger,MHQrcodeScanType) {
    MHQrcode_scanTypeNone ,                //不是我们要扫的码
    MHQrcode_scanTypeVem ,                //自助售卖机
    MHQrcode_scanTypeSeller,              //商家收款码,每个商户生成时，都生成一个专属商户二维码，用于商户出示给买家扫描进行定向付款；用户来扫
    MHQrcode_scanTypeScore,               //积分二维码(有条码)用于向商家支付使用，商家来扫
    MHQrcode_scanTypeCouponOrder,         //订单二维码(消费订单)
};

@interface MHQRCodeViewModel : NSObject

@property (strong,nonatomic) RACSubject *showHUDSubject;
@property (strong,nonatomic) RACSubject *compleSubject;

@property (nonatomic,assign) MHQrcodeScanType qrcodeType;

//从哪里进来的类型判断
@property (nonatomic,assign)MHQRCodeType type;

//是否正在请求数据
@property (nonatomic,assign)BOOL isRequesting;

//订单号
@property (nonatomic,copy)NSString *order_no;

/**
 解析二维码
 */
@property (strong,nonatomic) RACCommand *analyticQRCodeCommand;

//订单消费，订单详情
@property (nonatomic,strong,readonly)RACCommand *orderDetailCommand;
//订单消费
@property (nonatomic,strong,readonly)RACCommand *orderCostCommand;

//分析扫码出来的字符串,并自动给当前qrcodeType 赋值
- (NSString *)analyticQrcodeStringValue:(NSString *)qrcodeString;

//检测有没有权限扫
- (BOOL)checkScanLimit;
@end
