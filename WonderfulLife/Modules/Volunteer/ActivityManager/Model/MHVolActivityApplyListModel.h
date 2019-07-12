//
//  MHVolActivityApplyListModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolActivityApplyCrew;
@interface MHVolActivityApplyListModel : NSObject

@property (nonatomic, strong) NSNumber  *action_id;

@property (nonatomic, strong) NSNumber  *activity_id;

@property (nonatomic, strong) NSNumber  *team_id;

@property (nonatomic, strong) NSNumber  *qty;

@property (nonatomic, strong) NSNumber  *yty;

/** 已报名人员列表*/
@property (nonatomic, copy)   NSArray <MHVolActivityApplyCrew *>*applied;

/** 未报名人员列表*/
@property (nonatomic, copy)   NSArray <MHVolActivityApplyCrew *>*not_apply;


/**
 action_id	Long	22	活动id
 activity_id	Long	55	服务项目ID
 team_id	Long	33	服务队ID
 qty	Integer	8	活动名额
 yty	Integer	3	已报名数
 applied	Array<Crew>		已报名人员列表
 not_apply	Array<Crew>		未报名人员列表
 
 */
@end

@interface MHVolActivityApplyCrew : NSObject

@property (nonatomic, strong) NSNumber  *volunteer_id;

@property (nonatomic, copy)   NSString * volunteer_name;

@property (nonatomic, copy)   NSString * headphoto_s_url;

@property (nonatomic, strong) NSNumber  *user_id;
/** 志愿者在服务队的角色，0表示队员，1表示队长，9表示总队长*/
@property (assign,nonatomic) NSInteger role;

/** 是否可以取消报名，0不可取消，1可以取消 */
@property (nonatomic, assign) NSInteger isCancelApply;

@end
