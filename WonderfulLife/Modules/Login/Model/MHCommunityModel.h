//
//  MHCommunityModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHCommunityModel : NSObject

/** 区域ID */
@property (nonatomic,strong) NSNumber * community_id;

/** 区域名 */
@property (nonatomic,copy) NSString *community_name;

/** 区域地址 */
@property (nonatomic,copy) NSString *community_address;

/** 城市名*/
@property (nonatomic, copy)   NSString * city_name;

/**
 *  所在小区是否有房间号，0：否，1：是
 */
@property (assign,nonatomic) BOOL is_has_room;

+ (instancetype)communityFromUserInfo;
@end
