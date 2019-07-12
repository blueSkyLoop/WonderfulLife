//
//  MHVolSerItemManager.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolActiveModel ;
@interface MHVolSerItemManager : NSObject

@property (copy,nonatomic)NSArray<MHVolActiveModel *> * activity_list;

/** 用于 服务项目列表，是否能够切换城市*/
@property (nonatomic, assign) BOOL isSelectCity;

/** 已加入的服务组数量*/
@property (nonatomic, assign) NSInteger join_team_count;

@end
