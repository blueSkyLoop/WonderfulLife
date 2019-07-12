//
//  MHVoSerTeamManager.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  用于管理 服务队列表数组

#import <Foundation/Foundation.h>
#import "MHVolSerTeamModel.h"

@interface MHVoSerTeamManager : NSObject

@property (copy,nonatomic)NSArray<MHVolSerTeamModel *> * teams;

@property (nonatomic, assign) BOOL isShowJoinBtn;

@end
