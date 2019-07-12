//
//  MHVolSerVolInfo.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolSerVolInfo : NSObject

/*
 icon	String	 	志愿者头像
 sex	Integer	1	性别，1表示男，2表示女
 real_name	String	张学友	真实姓名
 role_name	String	总队长	志愿者角色名称（总队长、队长、队员）
 team_id	Long	1	服务队ID
 team_name	String	武汉人和天地治安巡逻队	服务队名称（城市+小区+服务队）
 all_integral	Integer	1234	爱心积分
 service_time	Integer	232	服务时长
 join_date	String	2017年3月13日	加入时间
 phone	String	13800138000	手机号

 is_approve_call	Integer	0	是够允许拨打电话，0表示不允许，1表示允许
 */

/// <#summary#>
@property (strong,nonatomic) NSURL *icon;
/// <#summary#>
@property (assign,nonatomic) NSInteger sex;
/// <#summary#>
@property (copy,nonatomic) NSString *real_name;
@property (copy,nonatomic) NSString *role_name;
/// <#summary#>
@property (strong,nonatomic) NSNumber *team_id;
/// <#summary#>
@property (copy,nonatomic) NSString *team_name;
/// <#summary#>
@property (copy,nonatomic) NSString *all_integral;
/// <#summary#>
@property (copy,nonatomic) NSString *service_time;
/// <#summary#>
@property (copy,nonatomic) NSString *join_date;
/// <#summary#>
@property (copy,nonatomic) NSString *phone;

/** is_approve_delete	Integer	0	是够允许删除该成员，0表示不允许，1表示允许 */
@property (assign,nonatomic) BOOL is_approve_delete;

@property (assign,nonatomic) BOOL is_approve_call;

/** 是否允许查看爱心积分 */
@property (nonatomic, assign) BOOL is_approve_view_score;

@end
