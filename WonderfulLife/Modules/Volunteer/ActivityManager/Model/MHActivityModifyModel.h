//
//  MHActivityModifyModel.h
//  WonderfulLife
//
//  Created by zz on 14/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHActivityModifyModel : NSObject

/**
 活动id
 */
@property (strong, nonatomic) NSNumber *action_id;

/**
 活动标题
 */
@property (copy  , nonatomic) NSString *title;

/**
 服务队id
 */
@property (strong, nonatomic) NSNumber *team_id;

/**
 服务队名称
 */
@property (copy  , nonatomic) NSString *team_name;

/**
 活动开始时间
 */
@property (copy  , nonatomic) NSString *date_begin;

/**
 活动结束时间
 */
@property (copy  , nonatomic) NSString *date_end;

/**
 活动地点
 */
@property (copy  , nonatomic) NSString *addr;

/**
 积分计算方法
 */
@property (copy  , nonatomic) NSString *score_rule_method;

/**
 活动人数
 */
@property (strong, nonatomic) NSNumber *qty;

/**
 已报名数
 */
@property (strong, nonatomic) NSNumber *yty;

/**
 活动介绍
 */
@property (copy  , nonatomic) NSString *intro;

/**
 活动规则
 */
@property (copy  , nonatomic) NSString *rule;

/**
 活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 */
@property (strong, nonatomic) NSNumber *action_type;

@end


/**
 
 
 名称	类型	示例值	描述
 action_id	Long	1	活动id
 title	String	治安巡逻队	活动标题
 team_id	Long	1	服务队id
 team_name	String	武汉太和园治安巡逻队	服务队名称
 date_begin	Date	2017-09-05 16:23	活动开始时间
 date_end	Date	2017-09-05 16:23	活动结束时间
 addr	String	武汉人和天地家政服务中心	活动地点
 score_rule_method	String	6分/小时	积分计算方法
 qty	Integer	8	活动人数
 yty	Integer	3	已报名数
 intro	String	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动介绍
 rule	String	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动规则
 action_type	Integer	0|1|2	活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 
 
 
*/
