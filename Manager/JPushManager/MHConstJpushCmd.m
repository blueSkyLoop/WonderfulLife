//
//  MHConstJpushCmd.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHConstJpushCmd.h"

@implementation MHConstJpushCmd
// 住户认证审核（结果）
NSString *const tenementValidateResult = @"tenement-validate-result";

// 申请加入服务项目
NSString *const volunteerAuditApply = @"volunteer-audit-apply";

// 加入服务项目-审核通过
NSString *const volunteerAuditPass = @"volunteer-audit-pass";

// 加入服务项目-审核拒绝
NSString *const volunteerAuditDeny = @"volunteer-audit-deny";

// 加入服务项目-撤回
NSString *const volunteerApplyWithdraw = @"volunteer-apply-withdraw";

// 队员被踢出服务队
NSString *const volunteerKick = @"volunteer-kick";

// 队员退出服务队
NSString *const volunteerExit = @"volunteer-exit";

// 被任命为总队长
NSString *const volunteerAppointChief = @"volunteer-appoint-chief";

// 总队长被革职
NSString *const volunteerKillChief = @"volunteer-kill-chief";

// 被任命为队长
NSString *const volunteerAppointCaptain = @"volunteer-appoint-captain";

// 队长被革职
NSString *const volunteerKillCaptain = @"volunteer-kill-captain";


// 被任命其他职务
NSString *const volunteerAppointOther = @"volunteer-appoint-other";

//  被解除其他职务
NSString *const volunteerKillOther = @"volunteer-kill-other";

// 获得积分
NSString *const getScore = @"get-score";

// 积分消费
NSString *const expendScore = @"expend-score";

//  职务积分发放
NSString *const sendScore = @"send-score";

//  缴纳物业费成功
NSString *const  propertyPay = @"property-pay";

//  订单已处理
NSString *const dealOrder = @"deal-order";

// 买 被扫码支付后，收到的支付结果
NSString *const qr_code_pay_result = @"qr_code_pay_result";

// 卖 被扫码支付后，收到的支付结果
NSString *const qr_code_charge_result = @"qr_code_charge_result";


// 商城权限是否开放
NSString *const mall_OpenOrClose = @"mall_OpenOrClose";

@end
