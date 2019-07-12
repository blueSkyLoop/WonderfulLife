//
//  MHVolSerCaptainModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolSerTeamIDTeamName;
@interface MHVolSerCaptainModel : NSObject
/*
 user_id	Long	10000133061710691	志愿者用户ID
 captain_name	String	张学友	队长名称
 captain_icon	String	xxx.jpg	队长头像
 phone	String	13800138000	队长手机号
 role	Integer	9	志愿者角色，0表示队长，9表示总队长
 */

/// <#summary#>
@property (strong,nonatomic) NSNumber *user_id;
/// <#summary#>
@property (copy,nonatomic) NSString *captain_name;

@property (strong,nonatomic) NSURL *captain_icon;
/// <#summary#>
@property (strong,nonatomic) NSURL *user_s_img;

@property (strong,nonatomic) NSURL *user_img;
/// <#summary#>
@property (copy,nonatomic) NSString *phone;
/// <#summary#>
@property (assign,nonatomic) NSInteger role;

/** 志愿者角色名称， */
@property (nonatomic, copy)   NSString * role_name;

@property (strong,nonatomic) NSNumber *volunteer_id;
@property (nonatomic,strong) NSArray <MHVolSerTeamIDTeamName *> *team_list;

@end
