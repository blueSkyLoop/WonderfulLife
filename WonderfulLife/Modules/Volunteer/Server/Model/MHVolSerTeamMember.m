//
//  MHVolSerteamMember.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerTeamMember.h"

@implementation MHVolSerTeamMember
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"team_list" : [MHVolSerTeamIDTeamName class]
             };
}

@end

@implementation MHVolSerTeamIDTeamName

@end

