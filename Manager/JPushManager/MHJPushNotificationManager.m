//
//  MHJPushNotificationManager.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MHJPushNotificationManager.h"
#import "MHConst.h"
#import "MHConstJpushCmd.h"
#import "NSObject+isNull.h"

#import "NSObject+CurrentController.h"
#import "UIViewController+PresentPayIncomResultController.h"
#import "MHMineMerchantPayModel.h"

#import "YYModel.h"

#import "MHJPushLogicMesList.h"
#import "MHJPushLogicStore.h"
#import "MHHUDManager.h"
@implementation MHJPushNotificationManager



+ (instancetype)manager{
    static MHJPushNotificationManager *jPush = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        jPush = [MHJPushNotificationManager new];
    });
    return jPush ;
}

- (void)jpush_notificationUserInfo:(NSDictionary *)userInfo stateType:(JPushStateType)stateType  {
    NSString *cmd = [userInfo objectForKey:@"cmd"];
    NSDictionary *data = userInfo[@"data"];
    
    if ([cmd isEqualToString:tenementValidateResult]) { // 刷新 住户认证结果
        [[NSNotificationCenter defaultCenter] postNotificationName:kTenementValidateResultNotification object:data];
    }else if ([cmd isEqualToString:qr_code_pay_result]) { // 买家收到的推送：支付结果
        MHMineMerchantPayModel * pay = [MHMineMerchantPayModel yy_modelWithJSON:data];
        MerColResultType type = pay.pay_result ? MerColResultType_CompPay : MerColResultType_FailurePay;
        UIViewController *vc = [NSObject mh_findTopestController];
        [vc mh_presentResultControllerWithModel:pay type:type];
        
    }else if ([cmd isEqualToString:qr_code_charge_result]){ // 卖家收到推送
        MHMineMerchantPayModel * pay = [MHMineMerchantPayModel yy_modelWithJSON:data];
        MerColResultType type = pay.income_result ? MerColResultType_CompIncome : MerColResultType_FailureIncome;
        UIViewController *vc = [NSObject mh_findTopestController];
        [vc mh_presentResultControllerWithModel:pay type:type];
        
    }else if ([cmd isEqualToString:propertyPay]){ // 物业缴费
       
        
    }else { //  跳转到消息列表
        if (stateType == JPushStateType_Inactive) { // 通知栏点击跳转
          [MHJPushLogicMesList JPushLogicMesList];
        }
    }
    
    
#if MH_Dev
    [MHHUDManager showText:@"收到了极光推送，这不是bug，仅用于调试提示"];
#elif MH_APPStore
    
#endif
    
}


- (void)jpush_customMsgUserInfo:(NSDictionary *)userInfo{
    // 自定义jpush消息，比推送多包了一层
    NSData *jsonData = [[userInfo objectForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    NSString *cmd = [dic objectForKey:@"cmd"];
    
    if ([cmd isEqualToString:mall_OpenOrClose]){
        
        [MHJPushLogicStore JpushLogicStore:dic];
        
    }else {  //  跳转到消息列表
        [MHJPushLogicMesList JPushLogicMesList];
    }

#if MH_Dev
    [MHHUDManager showText:@"收到了极光自定义消息，这不是bug，仅用于调试提示"];
#elif MH_APPStore
    
#endif
    
}



@end

