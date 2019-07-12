//
//  MHConstJpushCmd.h
//  WonderfulLife
//
//  Created by Lucas on 17/8/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHConstJpushCmd : NSObject

// 住户认证审核（结果）
extern NSString *const tenementValidateResult ;

// 申请加入服务项目
extern NSString *const volunteerAuditApply ;

// 加入服务项目-审核通过
extern NSString *const volunteerAuditPass ;

// 加入服务项目-审核拒绝
extern NSString *const volunteerAuditDeny ;

// 加入服务项目-撤回
extern NSString *const volunteerApplyWithdraw ;

// 队员被踢出服务队
extern NSString *const volunteerKick ;

// 队员退出服务队
extern NSString *const volunteerExit ;

// 被任命为总队长
extern NSString *const volunteerAppointChief ;

// 总队长被革职
extern NSString *const volunteerKillChief  ;

// 被任命为队长
extern NSString *const volunteerAppointCaptain ;

// 队长被革职
extern NSString *const volunteerKillCaptain ;


// 被任命其他职务
extern NSString *const volunteerAppointOther ;

//  被解除其他职务
extern NSString *const volunteerKillOther ;

// 获得积分
extern NSString *const getScore ;

// 积分消费
extern NSString *const expendScore ;

//  职务积分发放
extern NSString *const sendScore ;

//  缴纳物业费成功
extern NSString *const  propertyPay ;

//  订单已处理
extern NSString *const dealOrder ;

/** 买 家被扫码支付后，收到的支付结果 */
extern NSString *const qr_code_pay_result ;

/** 卖 家被扫码支付后，收到的支付结果 */
extern NSString *const qr_code_charge_result ;

/** 商城权限是否开放 */
extern NSString *const mall_OpenOrClose ;

@end
