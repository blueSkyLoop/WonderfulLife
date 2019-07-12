//
//  MHMerchantOrderDetailController.h
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMerchantOrderDetailViewModel.h"

typedef NS_ENUM(NSUInteger, MHMerchantOrderDetailControlType) {
    MHMerchantOrderDetailControlTypeCustomer, //买家详情
    MHMerchantOrderDetailControlTypeMerchant, //商家详情
    MHMerchantOrderDetailControlTypeRefund,   //退款详情
};

@interface MHMerchantOrderDetailController : UIViewController
@property (nonatomic,assign) MHMerchantOrderDetailControlType controlType;
/**
 订单id
 */
@property (nonatomic,copy) NSString *order_no;

@end
