//
//  MHCommunityModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCommunityModel.h"
#import "MHUserInfoManager.h"

@implementation MHCommunityModel
+ (instancetype)communityFromUserInfo {
    MHCommunityModel *model = [[MHCommunityModel alloc]init];
    model.community_id = [MHUserInfoManager sharedManager].community_id;
    model.community_name = [MHUserInfoManager sharedManager].community_name;
    return model;
}
@end
