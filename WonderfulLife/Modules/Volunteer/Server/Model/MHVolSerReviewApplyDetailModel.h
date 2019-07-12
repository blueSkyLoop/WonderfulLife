//
//  MHVolSerReviewApplyDetailModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolSerReviewApplyDetailModel : NSObject
@property (nonatomic, strong) NSNumber *apply_id;
@property (nonatomic, copy) NSString *headphoto_url;
@property (nonatomic, copy) NSString *headphoto_s_url;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *need_help;
@property (nonatomic, copy) NSString *apply_date;
@property (nonatomic, strong) NSNumber *apply_status;
@property (nonatomic, strong) NSNumber *captain;
@property (nonatomic, copy)   NSString * reason;
@property (nonatomic, copy)   NSString * activity_name;
@end

/*
 apply_id	Integer	1	申请记录ID
 headphoto_url	String		头像（大图）
 headphoto_s_url	String		头像(小图)
 real_name	String	张学友	姓名
 age	String	60岁	年龄
 phone	String	13622889090	电话
 address	String	广州市白云区黄边北路云山诗意6栋1103	住址
 hobby	String	足球、篮球、乒乓球	爱好特长
 need_help	String	病者伤残护理	需要帮助
 apply_date	String	2017-07-08	申请时间
 apply_status	Integer	0	审核状态，0表示审核中，1表示审核通过，2表示审核拒绝
 captain_mode	Integer	0	服务项目队长模式，0表示总队长模式，1表示普通模式，队长模式需要进入选择服务队页面，普通模式则跳过
 reason     String   拒绝理由
 activity_name  String  服务项目名称
 
 team_info	Json	{team_id:1, team_name:"治安巡逻队风和队"}	队长所在的服务队（当服务项目队长模式为普通模式时，有该信息）
 team_id	Long	1	服务队ID
 team_name	String	治安巡逻队风和队	服务队名称
 activity_summary	String	巡逻公共区域，制止不文明行为	服务项目简述
 captain_name	String	张学友	队长姓名
 headcount	Integer	19	队员人数
 */
