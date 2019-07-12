//
//  MHVolSerteamMember.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHVolSerTeamIDTeamName;

@interface MHVolSerTeamMember : NSObject

/// <#summary#>
@property (strong,nonatomic) NSNumber *user_id;
/// <#summary#>
@property (strong,nonatomic) NSURL *member_icon;
@property (strong,nonatomic) NSNumber *volunteer_id;

/** 志愿者小头像*/
@property (strong,nonatomic) NSURL * user_s_img;

/** 志愿者大头像*/
@property (strong,nonatomic) NSURL * user_img;
@property (nonatomic,strong) NSArray <MHVolSerTeamIDTeamName *> *team_list;

@end

@interface MHVolSerTeamIDTeamName : NSObject
@property (nonatomic, strong) NSNumber  *team_id;
@property (copy,nonatomic) NSString *team_name;

@end
