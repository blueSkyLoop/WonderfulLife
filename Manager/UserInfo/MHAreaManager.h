//
//  MHAreaManager.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  缓存小区的信息

#import <Foundation/Foundation.h>
#import "MHUserInfoManager.h"
@interface MHAreaManager : NSObject

 //-------------------------小区信息-----------------------------/
@property (nonatomic, strong) NSNumber *community_id;

@property (nonatomic, copy) NSString *community_name;

/** 商城权限 是否开放 YES:开放  NO:不开放*/
@property (nonatomic, assign) BOOL is_enable_mall_merchant;

/** 是否在“我的” 个人资料中切换  默认:NO*/
@property (nonatomic, assign) BOOL is_infoSwitch;

/** 判断是否打开简约版*/
@property (nonatomic, assign) BOOL isSimplyFlag;


/** 权限标志  0 默认，不作作何处理  1 有商城权限   2无商城权限 */
@property (nonatomic,assign)NSInteger status;


/** 刷新后自动跳转的界面  className*/
@property (nonatomic, copy)   NSString * className;

/** 是否需要刷新Tabbar */
@property (assign,nonatomic) BOOL isJpsuh_Reload;


// 2017.12.11 林威添加  serve_community_id & serve_community_name

/** 志愿服务站 id*/
@property (nonatomic, strong) NSNumber *serve_community_id;

/** 志愿服务站名*/
@property (nonatomic, copy) NSString *serve_community_name;
/*-------------------------公有方法-----------------------------*/
/**
 单例
 */
+ (instancetype)sharedManager;

/** 解析  缓存小区的信息 */
- (void)analyzingData:(NSDictionary *)data;

/** 存档 缓存小区的信息 */
- (void)saveAreaData;

/** 删档 缓存小区的信息 */
- (void)removeAreaData;

/** 获取当前定位小区*/
- (NSNumber *)getCommunityData ;

@end
