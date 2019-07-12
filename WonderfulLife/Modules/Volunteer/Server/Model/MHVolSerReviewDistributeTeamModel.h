//
//  MHVolSerReviewDistributeTeamModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolSerReviewDistributeTeamModel : NSObject
@property (nonatomic, strong) NSNumber *team_id;
@property (nonatomic, strong) NSNumber *headcount;

@property (nonatomic, copy) NSString *team_name;
@property (nonatomic, copy) NSString *activity_summary;
@property (nonatomic, copy) NSString *captain_name;


//业务逻辑 是否选中
@property (nonatomic, assign, getter=isSelectFlag) BOOL selectFlag;
@end

/*
 
 名称	类型	示例值	描述
 team_id	Long	1	服务队ID
 team_name	String	治安巡逻1队	服务队名称
 activity_summary	String	巡逻公共区域，制止不文明行为	服务项目简述
 captain_name	String	张学友	队长姓名
 headcount	Integer	19	队员人数
*/
