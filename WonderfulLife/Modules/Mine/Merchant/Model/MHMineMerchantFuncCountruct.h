//
//  MHMineMerchantFuncCountruct.h
//  WonderfulLife
//
//  Created by Lucas on 17/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHMineMerchantInfoModel ;
typedef NS_ENUM(NSInteger, MHMineMerchantType){
    
    MHMineMerchantType_orderCost  = 1,  // 订单消费
    
    MHMineMerchantType_orderManagement , // 订单管理
    
    MHMineMerchantType_QR ,         // 收款码
    
    MHMineMerchantType_reimburse , // 处理退款
    
    MHMineMerchantType_financial , // 财务报表
    
    MHMineMerchantType_collection , // 扫码收款
    
    MHMineMerchantType_withdrawal , // 提现
    
    MHMineMerchantType_idea , // 反馈意见
    
    MHMineMerchantType_call //  客服电话
};

@interface MHMineMerchantFuncCountruct : NSObject

+ (NSArray *)merFuncWithSource:(MHMineMerchantInfoModel *)info ;

@end




@interface MHMineMerchantFunctiomModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) MHMineMerchantType type;
@end
