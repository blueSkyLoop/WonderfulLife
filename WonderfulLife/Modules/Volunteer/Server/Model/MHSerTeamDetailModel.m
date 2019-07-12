//
//  MHSerTeamDetailModel.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHSerTeamDetailModel.h"

#import <YYModel.h>

@implementation MHSerTeamDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"captain_list" : NSClassFromString(@"MHVolSerCaptainModel"),
             @"team_member_list" : NSClassFromString(@"MHVolSerTeamMember"),
             };
}

@end
