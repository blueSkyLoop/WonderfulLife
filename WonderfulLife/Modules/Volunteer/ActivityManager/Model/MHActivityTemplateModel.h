//
//  MHActivityTemplateModel.h
//  WonderfulLife
//
//  Created by zz on 16/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHActivityTemplateModel : NSObject
/**
 活动模板id
 */
@property (strong, nonatomic) NSNumber *action_template_id;
/**
 活活动类型(即模板标题)
 */
@property (copy  , nonatomic) NSString *title;
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
 活动介绍
 */
@property (copy  , nonatomic) NSString *intro;
/**
 活动规则
 */
@property (copy  , nonatomic) NSString *rule;

@end

/**
 
 名称	类型	示例值	描述
 action_template_id	Long	1	活动模板id
 title	String	治安巡逻	活动类型(即模板标题)
 intro	String	负责武汉人和天地	活动介绍
 qty	Integer	1	活动人数
 date_begin	date	2017-9-6 11:41	活动开始时间
 date_end	date	2017-9-7 11:41	活动结束时间
 addr	String	太和园园区内	活动地点
 score_rule_method	String	6分/小时	积分计算方法
 rule	String	负责武汉人和天地	活动规则
 
 */
