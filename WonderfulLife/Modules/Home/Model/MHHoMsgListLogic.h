//
//  MHHoMsgListLogic.h
//  WonderfulLife
//
//  Created by Lucas on 17/8/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  消息通知逻辑跳转

#import <Foundation/Foundation.h>

@interface MHHoMsgListLogic : NSObject

/** 住户认证审核结果，返回到“我的”，刷新住户审核状态*/
+ (void)msgListLogicWithValidateWithResult:(BOOL)isSuccess ;

@end
