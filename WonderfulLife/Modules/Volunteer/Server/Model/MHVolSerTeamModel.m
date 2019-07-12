//
//  MHVolSerTeamModel.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerTeamModel.h"
#import "NSObject+isNull.h"

@implementation MHVolSerTeamModel


+ (BOOL)hasButtonWithArray:(NSArray <MHVolSerTeamModel *>*)array{
//    BOOL isHas = YES;
    int i  = 0;
    
    for (MHVolSerTeamModel * model in array) {
        
        if ([NSObject isNull:model.captain_name]) { // 审核中的项目是没有 “captain_name”的  需要加一
            i ++ ;
        }else{
            /// 志愿者在服务队的角色，0表示队员，1表示队长，9表示总队长
            if (model.role_in_team == 9) {
                if (i>0)i -- ;
            }else{
                i ++ ;
            }
        }
        if (i >= 2) {
            return NO;
        }
    }
    return YES ;
}

@end
