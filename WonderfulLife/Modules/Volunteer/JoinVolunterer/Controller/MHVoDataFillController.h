//
//  MHVoDataFillController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoDataFillController : UIViewController
/**
 需求，需求，需求
 标识是否未注册，且从志愿者界面点击加入我们按钮触发登录并注册
 目的：去掉两个界面
 */
@property (nonatomic, assign) BOOL loginFlag;
@property (nonatomic,copy) NSString *room_info;

// fromIndex 为1 表示从积分支付时发现没有注册过来的  日后可扩展
@property (nonatomic, assign) NSInteger fromIndex;

@end
