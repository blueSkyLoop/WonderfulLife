//
//  MHConst.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHConst.h"

@implementation MHConst

NSString *const  kErrorMsgNoNetWork = @"手机无网络，请检查后再试！";

NSString *const  kErrorMsg = @"网络繁忙，请稍后再试！";

NSString *const  kPROHIBITINPUTEXPRESSION = @"请不要输入表情符号";


#pragma mark -- Notification Name
NSString *const kLoginAgainNotification = @"loginAgainNotification";

NSString *const kComeinAPPNotification = @"kComeinAPPNotification";

NSString *const kReloadStoreHomeNotification = @"kReloadStoreHomeNotification";

/** 刷新首页数据 */
NSString *const kReloadHomeControllerDataNotification = @"kReloadHomeControllerDataNotification";

NSString *const kReloadVoSerTeamNotification = @"kReloadVoSerTeamNotification";

NSString *const kReloadVoSerDetailNotification = @"kReloadVoSerDetailNotification";


NSString *const kReloadVolunteerHomePageNotification = @"reloadVolunteerHomePageNotification";
NSString *const kReloadVolunteerReviewPageNotification = @"kReloadVolunteerReviewPageNotification";


NSString *const kReplaceViewControllerNotification = @"kReplaceViewControllerNotification";

NSString *const kReloadMsgNotifiDataSource = @"kReloadMsgNotifiDataSource";

#pragma mark -- Notification Key
NSString *const kShowInvitePage = @"showInvitePage";

#pragma mark -- NSUserDefaults Key
NSString *const kTokenKey = @"tokenKey";
NSString *const kAccount = @"account";

NSString *const kVolunteerServerInfo = @"volunteerServerInfo";
NSString *const kVolunteerServerFuncModelArray = @"volunteerServerFuncModelArray";
/** 我的资料卡-修改需要帮助*/
NSString *const kReloadVolSerMyCardControllerDataNotification = @"kReloadVolSerMyCardControllerDataNotification";
/** 我的资料卡-修改住址*/
NSString *const kReloadVolSerMyCardControllerAddressNotification = @"kReloadVolSerMyCardControllerAddressNotification";

NSString *const  kTenementValidateResultNotification = @"kTenementValidateResultNotification";
NSString *const  kReloadVolSerActivityListResultNotification = @"kReloadVolSerActivityListResultNotification";
NSString *const  kReloadVolSerActivityListResultToTopNotification = @"kReloadVolSerActivityListResultToTopNotification";

NSString *const  MHVoRegisterAttendanceControllerReloadNotification = @"MHVoRegisterAttendanceControllerReloadNotification";

//刷新投诉报修列表
NSString *const  kReloadReportRepairListNotification = @"kReloadReportRepairListNotification";
//发矶成功
NSString *const  kReportRepairPublishSuccessNotification = @"kReportRepairPublishSuccessNotification";
//商品订单支付成功通知
NSString *const  kStoreOrderPaySuccessNotification = @"kStoreOrderPaySuccessNotification";
//退款成功通知
NSString *const  kStoreRefundSuccessNotification = @"kStoreRefundSuccessNotification";

@end
