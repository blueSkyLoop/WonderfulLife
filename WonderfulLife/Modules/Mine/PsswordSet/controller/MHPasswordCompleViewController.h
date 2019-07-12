//
//  MHPasswordCompleViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "MHNavigationControllerManager.h"
typedef NS_ENUM(NSInteger,MHAlertShowType) {
    MHAlertShow_passwordComple = 1,                   //支付密码设置成功
    MHAlertShow_passwordFailure,                      //支付密码设置失败
    MHAlertShow_notVolunteer,                         //不是志愿者
    MHAlertShow_integralsLess                         //积分余额不足
};

@interface MHPasswordCompleViewController : MHBaseViewController<MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)RACSubject *callBackSubject;

- (id)initWithAlertType:(MHAlertShowType)type;

@end
