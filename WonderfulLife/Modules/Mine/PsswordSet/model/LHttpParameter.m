//
//  LHttpParameter.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LHttpParameter.h"
#import "LCommonModel.h"

@implementation LHttpParameter

//设置支付密码
+ (NSDictionary *)setPayPasswordWithToken:(NSString *)token pay_password:(NSString *)pay_password{
    return @{@"token":token?:@"",
             @"pay_password":[LCommonModel md532BitLowerKey:pay_password]
             };
}
//校验原支付密码
+ (NSDictionary *)validatePayWithToken:(NSString *)token pay_password:(NSString *)pay_password{
    return @{@"token":token?:@"",
             @"pay_password":[LCommonModel md532BitLowerKey:pay_password]
             };
}
//获取验证码-忘记密码
+ (NSDictionary *)forgetPasswordSmsCodeWithToken:(NSString *)token phone:(NSString *)phone{
    return @{@"token":token?:@"",
             @"phone":phone
             };
}
//校验验证码-忘记密码
+ (NSDictionary *)forgetPasswordSmsCodeValidateWithToken:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code{
    return @{@"token":token?:@"",
             @"phone":phone,
             @"sms_code":sms_code
             };
}
//动态设置校验验证码（方便调试）-忘记密码
+ (NSDictionary *)dynamicForgetPasswordSmsCodeValidateWithToken:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code{
    return @{@"token":token?:@"",
             @"phone":phone,
             @"sms_code":sms_code
             };
}
//自助售卖机订单支付
+ (NSDictionary *)vemPaymentPayWithToken:(NSString *)token payment_id:(NSInteger)payment_id pay_password:(NSString *)pay_password{
    return @{@"token":token?:@"",
             @"payment_id":@(payment_id),
             @"pay_password":[LCommonModel md532BitLowerKey:pay_password]
             };
}

@end
