//
//  MHLoSetPlotController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
/// 设置小区 

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHLoSetPlotTypeUndefined,
    MHLoSetPlotTypeLogin,  // 登录注册
    MHLoSetPlotTypeCertifi, // 住户认真
    MHLoSetPlotTypePay,     // 物业缴费
    MHLoSetPlotTypeAddress,  // 申请“志愿者”填写资料 -> 添加地址
    MHLoSetPlotTypeReportRepairNew, // 投诉报修
} MHLoSetPlotType;

@interface MHLoSetPlotController : UIViewController


@property (assign,nonatomic) MHLoSetPlotType setType;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *repair_room_json;
@property (nonatomic,strong) NSNumber *repair_community_id;

/**
 需求，需求，需求
 标识是否未注册，且从志愿者界面点击加入我们按钮触发登录并注册
 目的：去掉两个界面
 */
@property (nonatomic, assign) BOOL joinVolunteerFlag;

/** 从首页进就push,其余pop并刷新缴费房间列表 */
@property (nonatomic,assign) BOOL fromHome;

@end
