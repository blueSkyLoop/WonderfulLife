//
//  MHVolActivityListModel.h
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolActivityListModel : NSObject

/**
 服务队列关联id
 */
@property (strong ,nonatomic) NSNumber *action_team_ref_id;
/**
 活动id
 */
@property (strong ,nonatomic) NSNumber *action_id;
/**
 活动标题
 */
@property (copy   ,nonatomic) NSString *title;
/**
 活动开始时间
 */
@property (copy   ,nonatomic) NSString *date_begin;
/**
 活动结束时间
 */
@property (copy   ,nonatomic) NSString *date_end;
/**
 活动地点
 */
@property (copy   ,nonatomic) NSString *addr;
/**
 活动人数
 */
@property (strong ,nonatomic) NSNumber *qty;
/**
 活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 */
@property (strong ,nonatomic) NSNumber *action_type;
/**
 活动状态，0报名中，1名额已满，2进行中，3已结束
 */
@property (strong ,nonatomic) NSNumber *action_state;
/**
 活动是否已经取消，0表示未取消，1表示已取消
 */
@property (strong ,nonatomic) NSNumber *is_cancel;
/**
 当action_state为3时，此参数无效，是否分队长，0否，1是
 */
@property (strong ,nonatomic) NSNumber *is_captain;
/**
 当action_state为3时，此参数无效，是否已报名，0否，1是
 */
@property (strong ,nonatomic) NSNumber *is_apply;
/**
 当action_state为3时，默认为0，活动时间是否已结束，0未结束，1已结束
 */
@property (strong ,nonatomic) NSNumber *is_action_end;

@property (strong ,nonatomic) NSNumber *team_id;

@end


/**
 
 名称    类型    示例值    描述
 action_team_ref_id    Long    1    服务队列关联id
 action_id    Long    1    活动id
 title    String    治安巡逻队    活动标题
 date_begin    Date    2017-09-05 16:23    活动开始时间
 date_end    Date    2017-09-05 16:23    活动结束时间
 addr    String    武汉人和天地家政服务中心    活动地点
 qty    Integer    5    活动人数
 action_type    Integer    0|1|2    活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 action_state    Integer    0|1|2|3    活动状态，0报名中，1名额已满，2进行中，3已结束
 is_cancel    Integer    0|1    活动是否已经取消，0表示未取消，1表示已取消
 is_action_end    Integer    0|1    当action_state为3时，默认为0，活动时间是否已结束，0未结束，1已结束
 is_captain    Integer    0|1    当action_state为3时，默认为0，是否分队长，0否，1是
 is_apply    Integer    0|1    当action_state为3时，默认为0，是否已报名，0否，1是
 
 */
