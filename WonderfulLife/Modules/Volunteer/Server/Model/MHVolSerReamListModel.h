//
//  MHVolSerReamListModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHVoSeAttendanceRegisterCommitModel;

@interface MHVolSerReamListModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id_type;

@property (nonatomic, copy) NSString *is_captain;
@property (nonatomic,copy) NSString *headphoto_s_url;

@property (nonatomic, copy)   NSString * role_name;

@property (nonatomic, copy)   NSString * real_name;
//业务逻辑
@property (nonatomic, assign) NSInteger timeCountFlag;  //记录登记时的时长
@property (nonatomic, strong) MHVoSeAttendanceRegisterCommitModel *commitDataModel; //记录登记model
@end

/*
 名称	类型	示例值	描述
 id	Long	1	id
 name	String	治安巡逻1队	服务项目或服务队名称
 id_type	String	a|t	数据类型，a 表示服务项目，t 表示服务队
*/

/*
is_captain	String	0	0表示队员，1表示队长
*/
