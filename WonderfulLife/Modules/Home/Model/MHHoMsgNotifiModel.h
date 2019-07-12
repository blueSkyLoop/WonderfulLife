//
//  MHHoMsgNotifiModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHExtData,MHData;
@interface MHHoMsgNotifiModel : NSObject

/** 推送消息的id */
@property (nonatomic,strong) NSNumber *notification_id;

/** 消息标题 */
@property (nonatomic,copy) NSString *subject;

/** 0:没有读;1:已读 */
@property (nonatomic,strong) NSNumber *is_read;

/** 消息发布时间 */
@property (nonatomic,copy) NSString *create_datetime;

/** 推送消息的json格式 */
@property (nonatomic,strong) MHExtData *ext_data;

@property (nonatomic,assign) float cellHeight;

@end



@interface MHExtData : NSObject

/** 标题*/
@property (nonatomic, copy)   NSString * title;

/** 推送类型 */
@property (nonatomic, copy)   NSString * cmd;

/** 推送内容 */
@property (nonatomic, copy)   NSString * msg;

/** 附加信息*/
@property (nonatomic, strong)   MHData * data;


@end


@interface MHData : NSObject

/** 志愿者ID*/
@property (nonatomic, strong) NSNumber  *volunteer_id;

/** 用户ID*/
@property (nonatomic, strong) NSNumber  *user_id;

/** 服务项目ID*/
@property (nonatomic, strong) NSNumber  *activity_id;

/** 申请ID*/
@property (nonatomic, strong) NSNumber  *apply_id;

/** 姓名*/
@property (nonatomic, copy)   NSString * real_name;

/** 住户认证审核（结果） 0表示审核不通过，1表示审核通过*/
@property (nonatomic, assign) BOOL is_success;
/** 住户认证审核表*/
@property (nonatomic, strong) NSNumber  *lv_id;

/** 服务队ID*/
@property (nonatomic, strong) NSNumber  *team_id;

/** 职务id*/
@property (nonatomic, strong) NSNumber  *duty_id;

/** 职员id*/
@property (nonatomic, strong) NSNumber  *staff_id;


@end

