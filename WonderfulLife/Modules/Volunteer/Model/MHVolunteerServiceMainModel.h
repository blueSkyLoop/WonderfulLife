//
//  MHVolunteerServiceMainModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolunteerServiceMainModel : NSObject
@property (nonatomic, strong) NSNumber *all_integral;
@property (nonatomic, strong) NSString *modify_datetime;
@property (nonatomic, strong) NSNumber *role;
@property (nonatomic, strong) NSArray *approving_projects;
@property (nonatomic, strong) NSNumber *is_promise_approve;
@property (nonatomic, strong) NSNumber *is_lt_3h;
@property (nonatomic, strong) NSArray  *volunteer_list;
@end
/*
 
 名称	类型	示例值	描述
 all_integral	Integer	328	我的爱心积分
 modify_datetime	String	2017-10-10	更新时间
 role	Integer	1	志愿者角色，0表示队员，1表示队长，9表示总队长
 approving_projects	Array	["武汉人和天地治安巡逻","武汉人和天地环境监察"]	审核中项目集合
 is_promise_approve	Integer	0	队长是否代行总队长权限，0表示不代行，1表示代行
 is_lt_3h	Integer	0	上个月服务时长是否低于3小时，0表示不是，1表示是
 */
