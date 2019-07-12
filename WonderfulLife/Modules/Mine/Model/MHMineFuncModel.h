//
//  MHMineFuncModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MHMineFuncModelType){
    
    /**  爱心积分*/
    MHMineFuncModelType_LovePoints  = 0,
    
    /** 小区住户*/
     MHMineFuncModelType_Community ,
    
    /** 周边订单 */
    MHMineFuncModelType_Order ,
    
    /** 我是商家*/
    MHMineFuncModelType_Merchant ,
    
    /** 积分二维码*/
    MHMineFuncModelType_IntQrCode ,
    
    /** 设置 */
    MHMineFuncModelType_Setting
    
};
@interface MHMineFuncModel : NSObject

@property (nonatomic, copy)   NSString * title;

@property (nonatomic, assign) MHMineFuncModelType type;


+ (NSArray *)mineFuncs ;

@end
