//
//  MHMineMerColResultController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  扫码支付结果  ： 成功 | 失败

#import <UIKit/UIKit.h>
#import "MHMerPayIncomEnumResult.h"
@class MHMineMerchantPayModel ;
typedef NS_ENUM(NSInteger, MerResultOpenType){ // 打开方式
    
    /** push */
    MerResultOpenType_Push  = 0,
    
    /** Present */
    MerResultOpenType_Present
    
};
@interface MHMineMerColResultController : UIViewController

- (instancetype)initWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type openType:(MerResultOpenType)openType;

@end
