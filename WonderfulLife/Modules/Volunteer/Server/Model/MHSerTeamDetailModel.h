//
//  MHSerTeamDetailModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolSerCaptainModel,MHVolSerTeamMember;
@interface MHSerTeamDetailModel : NSObject

/*
 community_name	String	武汉人和天地	小区名称（城市+小区）
 activity_id	Long	1	服务项目ID
 team_name	String	治安巡逻一队	服务队名称
 activity_intro	String	负责武汉人和天地泰和园的日常治安巡逻...	服务项目介绍
 is_quit	Integer	0	是否退出服务队，0表示未退出，1表示已退出
 approve_status	Integer	0	审核状态，-1表示未申请该服务项目或已撤销申请，0表示待审核，1表示审核通过，2表示审核未通过，3表示已退出，4表示被移除
 captain_list	 	 	队长列表(如果有总队长，则总队长在最前面)
 team_member_list	 	 	队员列表
 */

/// <#summary#>
@property (copy,nonatomic) NSString *community_name;
/// <#summary#>
@property (strong,nonatomic) NSNumber *activity_id;
/// <#summary#>
@property (copy,nonatomic) NSString *team_name;
/// <#summary#>
@property (copy,nonatomic) NSString *activity_intro;
/** 已加入项目的数量*/
@property (nonatomic, assign) NSInteger activity_count;

/** 拒绝理由： 被移除的原因/审核不通过原因 */
@property (nonatomic, copy)   NSString * reason;

@property (nonatomic, copy)   NSString * activity_name;

/**  志愿者在 服务队/服务项目里的身份  0：队员   1：队长   9：总队长 */
@property (nonatomic, assign) NSInteger  volunteer_role;

/** 服务项目类型，0表示公益服务项目，1表示普通服务项目 */
@property (nonatomic, strong) NSNumber  *activity_type;

/// <#summary#>
@property (assign,nonatomic) BOOL is_quit;
/// <#summary#>
@property (assign,nonatomic) NSInteger approve_status;
/// <#summary#>
@property (strong,nonatomic) NSArray<MHVolSerCaptainModel *> *captain_list;
/// <#summary#>
@property (strong,nonatomic) NSArray<MHVolSerTeamMember *> *team_member_list;


@property (nonatomic, strong) NSNumber  *team_id;

@property (nonatomic, strong) NSNumber  *community_id;

@end
