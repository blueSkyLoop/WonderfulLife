//
//  MHConst.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHConst : NSObject

#pragma mark -- Const String
/**
 *  无网络时错误
 */
extern NSString *const  kErrorMsgNoNetWork ;

/**
 *  后台报错
 */
extern NSString *const  kErrorMsg ;

/**
 *  不能使用表情 提示
 */
extern NSString *const  kPROHIBITINPUTEXPRESSION ;


#pragma mark -- Notification Name
/** 重新登录 */
extern NSString *const  kLoginAgainNotification;

/** 进入app */
extern NSString *const  kComeinAPPNotification;

extern NSString *const  kReloadHomeControllerDataNotification;

/** 刷新志愿者首页界面 */
extern NSString *const  kReloadVolunteerHomePageNotification;

/** 刷新志愿者首页界面 */
extern NSString *const  kReloadStoreHomeNotification;

/** 刷新志愿者审核界面 */
extern NSString *const  kReloadVolunteerReviewPageNotification;

/** 刷新我的服务队列表数据 */
extern NSString *const  kReloadVoSerTeamNotification;

/** 刷新服务详情页数据 */
extern NSString *const  kReloadVoSerDetailNotification;

/** 刷新志愿者状态 */
extern NSString *const  kTenementValidateResultNotification;

/** 替换控制器 */
extern NSString *const  kReplaceViewControllerNotification;

/** 刷新消息通知数据*/
extern NSString *const kReloadMsgNotifiDataSource ;

#pragma mark -- Notification Key
extern NSString *const kShowInvitePage;

#pragma mark -- NSUserDefaults Key
/** token */
extern NSString *const kTokenKey;
/** 登录帐号 */
extern NSString *const kAccount;

/** 服务页信息 */
extern NSString *const kVolunteerServerInfo;
/** 服务页功能组件模型 */
extern NSString *const kVolunteerServerFuncModelArray;
/** 我的资料卡-修改需要帮助*/
extern NSString *const kReloadVolSerMyCardControllerDataNotification;
/** 我的资料卡-修改住址*/
extern NSString *const kReloadVolSerMyCardControllerAddressNotification;
/** 活动管理-活动列表*/
extern NSString *const  kReloadVolSerActivityListResultNotification;
extern NSString *const  kReloadVolSerActivityListResultToTopNotification;

extern NSString *const  MHVoRegisterAttendanceControllerReloadNotification;

//刷新投诉报修列表
extern NSString *const  kReloadReportRepairListNotification;
//发布成功
extern NSString *const  kReportRepairPublishSuccessNotification;
//商品订单支付成功通知
extern NSString *const  kStoreOrderPaySuccessNotification;
//退款成功通知
extern NSString *const  kStoreRefundSuccessNotification;


@end
