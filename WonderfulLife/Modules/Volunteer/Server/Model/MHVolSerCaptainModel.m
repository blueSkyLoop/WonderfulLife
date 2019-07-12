//
//  MHVolSerCaptainModel.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerCaptainModel.h"
#import "MHVolSerTeamMember.h"

@implementation MHVolSerCaptainModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"team_list" : [MHVolSerTeamIDTeamName class]
             };
}

@end
