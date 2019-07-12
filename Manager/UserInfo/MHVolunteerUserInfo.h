//
//  MHVolunteerUserInfo.h
//  WonderfulLife
//
//  Created by zz on 18/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolunteerUserInfoAddress;
@interface MHVolunteerUserInfo : NSObject

/**
 志愿者ID
 */
@property (strong, nonatomic) NSNumber  *volunteer_id;
/**
 志愿者角色
 
 职务：
 志愿者角色，0表示队员，1表示队长，2表示虚拟志愿者，9表示总队长

 Tip:该属性是在MHVoServerPageController类的方法 requestGetData 中 402 行赋值；
 */
@property (strong, nonatomic) NSNumber  *volunteer_role;
/**
 活动管理-活动列表-志愿者角色
 
 职务：
 志愿者角色，0表示队员，1表示队长
 
 */
@property (strong, nonatomic) NSNumber  *volunteer_is_captain;
/**
 照片大图
 */
@property (copy  , nonatomic) NSString *user_img;
/**
 照片小图
 */
@property (copy  , nonatomic) NSString *user_s_img;
/**
 姓名
 */
@property (copy  , nonatomic) NSString *real_name;
/**
 身份证
 */
@property (copy  , nonatomic) NSString *identity_card;
/**
 性别
 */
@property (copy  , nonatomic) NSString *sex;
/**
 生日
 */
@property (copy  , nonatomic) NSString *birthday;
/**
 手机号码
 */
@property (copy  , nonatomic) NSString *phone;
/**
 兴趣爱好
 */
@property (copy  , nonatomic) NSString *tag;
/**
 服务名称
 */
@property (copy  , nonatomic) NSString *support;
/**
 住址
 */
@property (strong, nonatomic) MHVolunteerUserInfoAddress *address;

///Tip - 请使用单例
+ (instancetype)sharedInstance;
/**
 清理单例数据
 */
+ (void)clear;
@end

//------------------------- 用 户 住 址 -----------------------------/

@interface MHVolunteerUserInfoAddress : NSObject
/**
 城市
 */
@property (copy  , nonatomic) NSString *city;
/**
 地区
 */
@property (copy  , nonatomic) NSString *community;
/**
 房间号
 */
@property (copy  , nonatomic) NSString *room;
@property (nonatomic,assign,getter=isLocalWrite) BOOL localWrite;
@end

