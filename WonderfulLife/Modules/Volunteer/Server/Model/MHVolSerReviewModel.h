//
//  MHVolSerReviewModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolSerReviewModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, strong) NSNumber *apply_id;
@property (nonatomic, copy) NSString *apply_date;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, strong) NSNumber *status;
@end

/*
 名称	类型	示例值	描述
 icon	String	bbb.jpg	志愿者头像
 real_name	String	张学友	真实姓名
 apply_id	Long	1	申请记录ID
 apply_date	String	2016-10-10	申请时间
 activity_name	String	武汉人和天地治安巡逻	服务项目名称（城市+小区+服务项目）
 status	Integer	0	审核状态，0表示待审核，1表示审核通过，2表示审核不通过 3表示已撤回
*/
