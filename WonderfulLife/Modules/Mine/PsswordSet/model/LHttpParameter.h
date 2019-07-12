//
//  LHttpParameter.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const API_SetPayPassword = @"account/setPayPassword";                                              //设置支付密码
static NSString *const API_ValidatePayPassword = @"account/validatePayPassword";                                    //校验原支付密码
static NSString *const API_ForgetPasswordSmsCode_get = @"sms/forgetPasswordSmsCode/get";                            //获取验证码-忘记密码
static NSString *const API_ForgetPasswordSmsCode_Validate = @"sms/forgetPasswordSmsCode/validate";                  //校验验证码-忘记密码
static NSString *const API_SetForgetPayPasswordSmsCode = @"sms/setForgetPayPasswordSmsCode";                        //动态设置校验验证码（方便调试）-忘记密码
static NSString *const API_Vem_payment_pay = @"vem-payment/pay";                                                    //自助售卖机订单支付



@interface LHttpParameter : NSObject

//设置支付密码
+ (NSDictionary *)setPayPasswordWithToken:(NSString *)token pay_password:(NSString *)pay_password;
//校验原支付密码
+ (NSDictionary *)validatePayWithToken:(NSString *)token pay_password:(NSString *)pay_password;
//获取验证码-忘记密码
+ (NSDictionary *)forgetPasswordSmsCodeWithToken:(NSString *)token phone:(NSString *)phone;
//校验验证码-忘记密码
+ (NSDictionary *)forgetPasswordSmsCodeValidateWithToken:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code;
//动态设置校验验证码（方便调试）-忘记密码
+ (NSDictionary *)dynamicForgetPasswordSmsCodeValidateWithToken:(NSString *)token phone:(NSString *)phone sms_code:(NSString *)sms_code;
//自助售卖机订单支付
+ (NSDictionary *)vemPaymentPayWithToken:(NSString *)token payment_id:(NSInteger)payment_id pay_password:(NSString *)pay_password;

@end
