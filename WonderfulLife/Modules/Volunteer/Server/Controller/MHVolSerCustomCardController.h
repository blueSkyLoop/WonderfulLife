//
//  MHVolSerCustomCardController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  志愿者个人卡片

#import <UIKit/UIKit.h>

@interface MHVolSerCustomCardController : UIViewController
@property (strong,nonatomic) NSNumber *userId; // 用户id
@property (strong,nonatomic) NSNumber *activtyId; // 项目id
@property (strong,nonatomic) NSNumber *volunteerId; // 用户id

@property (strong,nonatomic) NSNumber *teamId;

@property (nonatomic, assign) NSInteger  role;   // 用户的身份  ： 队员：0、队长：1、总队长：9

@end
