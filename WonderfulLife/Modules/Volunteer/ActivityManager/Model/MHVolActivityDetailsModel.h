//
//  MHVolActivityDetailsModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHVolSerCaptainModel.h"
@class MHVolSerTeamMember;
@interface MHVolActivityDetailsModel : NSObject



//@property (nonatomic, strong) NSNumber  *volunteer_id;

@property (nonatomic, strong) NSNumber  *action_id;

/** action_team_ref_id 活动与服务队关系id*/
@property (nonatomic, strong) NSNumber  *action_team_ref_id;

@property (nonatomic, copy)   NSString * title;

@property (nonatomic, strong) NSNumber  *team_id;

@property (nonatomic, copy)   NSString * team_name;

@property (nonatomic, copy)   NSString  *date_begin;

@property (nonatomic, copy)   NSString  *date_end;

@property (nonatomic, copy)   NSString * addr;

@property (nonatomic, copy)   NSString * times;

@property (nonatomic, copy)   NSString * score_rule_method;

/**  qty	Integer	8	可以参加活动人数  0 显示不限*/
@property (nonatomic, assign) NSInteger qty;

/**  sty	Integer	3	剩名额数*/
@property (nonatomic, assign) NSInteger sty;

@property (nonatomic, copy)   NSString * intro;

@property (nonatomic, copy)   NSString * rule;

/** action_type	Integer	0|1|2	活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动*/
@property (nonatomic, assign) NSInteger action_type;

/** is_cancel	Integer	0|1	活动是否已经取消，0表示未取消，1表示已取消*/
@property (nonatomic, assign) NSInteger is_cancel;

/** is_captain	Integer	0|1	是否分队长，0否，1是*/
@property (nonatomic, assign) NSInteger is_captain;

/** action_state	Integer	0|1|2|3	活动状态，0报名中，1名额已满，2进行中，3已结束*/
@property (nonatomic, assign) NSInteger action_state;

/** is_apply 是否已报名，0否，1是*/
@property (nonatomic, assign) NSInteger is_apply;

/** is_attendance 是否登记了考勤  0：没登记过  1：已登记*/
@property (nonatomic, assign) NSInteger is_attendance;

@property (nonatomic, strong) MHVolSerCaptainModel  *captain;

@property (strong,nonatomic) NSArray<MHVolSerTeamMember *> *team_member_list;

/** is_action_end 	当action_state为3时，默认为0，活动时间是否已结束，0未结束，1已结束 */
@property (nonatomic, assign) NSInteger is_action_end;

@property (nonatomic, strong) NSNumber  *activity_id;

@property (nonatomic, assign) BOOL isOpenIntro;

@property (nonatomic, assign) BOOL isOpenRules;


/**
 action_id	Long	1	活动id
 title	String	治安巡逻队	活动标题
 team_id	Long	1	服务队id
 team_name	String	武汉太和园治安巡逻队	服务队名称
 date_begin	Date	2017-09-05 16:23	活动开始时间
 date_end	Date	2017-09-05 16:23	活动结束时间
 addr	String	武汉人和天地家政服务中心	活动地点
 times	String	4小时15分	时长
 score_rule_method	String	6分/小时	积分
 qty	Integer	8	活动人数
 sty	Integer	3	剩名额数
 intro	String	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动介绍
 rule	String	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动规则
 
 captain	 	 	分队长
 user_id	Long	10000133061710691	志愿者用户ID
 captain_name	String	张学友	队长名称
 captain_icon	String	xxx.jpg	队长头像
 team_member_list	 	 	队员列表
 user_id	Integer	10000133061710691	志愿者用户ID
 member_icon	String	xxx.jpg	志愿者用户头像
 */

/*
action_type	Integer	0|1|2	活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
is_cancel	Integer	0|1	活动是否已经取消，0表示未取消，1表示已取消
is_captain	Integer	0|1	当action_state为3时，默认为0，是否分队长，0否，1否
is_action_end	Integer	0|1	当action_state为3时，默认为0，活动时间是否已结束，0未结束，1已结束
is_apply	Integer	0|1	当action_state为3时，默认为0，是否已报名，0否，1是
action_state	Integer	0|1|2|3	活动状态，0报名中，1名额已满，2进行中，3已结束
*/

+ (MHVolActivityDetailsModel *)model;
@end
