//
//  MHVolSerTeamModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /**  审核通过*/
    MHVolSerTeamPassd,
    
    /** 审核中*/
    MHVolSerTeamApproving,
    
    /** 不通过*/
    MHVolSerTeamUnPass,
    
    /** 已退出*/
    MHVolSerTeamQuit,
    
    /** 已撤回*/
    MHVolSerTeamWithdraw
    
} MHVolSerTeamType;

@interface MHVolSerTeamModel : NSObject

/// 服务项目ID，登录用户为总队长时，服务队名称显示的是服务项目名+队
@property (strong,nonatomic) NSNumber *project_id;
/// 服务项目名称
@property (copy,nonatomic) NSString *project_name;
/// 小区名称
@property (copy,nonatomic) NSString *community_name;
/// 服务队ID
@property (strong,nonatomic) NSNumber *team_id;
/// 服务队名称
@property (copy,nonatomic) NSString *team_name;
/// 服务项目概述
@property (copy,nonatomic) NSString *project_summary;
/// 队长名称
@property (copy,nonatomic) NSString *captain_name;
/// 人数
@property (strong,nonatomic) NSNumber *people_count;

/** 服务项目类型，0表示公益服务项目，1表示普通服务项目 */
@property (nonatomic, assign) NSInteger activity_type;

@property (nonatomic, copy)   NSString * role_name;

/** 志愿者在服务队的角色，0表示队员，1表示队长，9表示总队长*/
@property (assign,nonatomic) NSInteger role_in_team;
/// 队长是否代行总队长权限，0表示不代行，1表示代行
@property (assign,nonatomic) BOOL is_promise_approve;

#pragma mark - 自加属性，服务队的类型
@property (assign,nonatomic) MHVolSerTeamType type;


@property (nonatomic, assign) BOOL hasButton;

+ (BOOL)hasButtonWithArray:(NSArray <MHVolSerTeamModel *>*)array;

@end
