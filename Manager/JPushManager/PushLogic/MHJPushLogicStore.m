//
//  MHJPushLogicStore.m
//  WonderfulLife
//
//  Created by Lol on 2017/12/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHJPushLogicStore.h"
#import "MHAreaManager.h"
@implementation MHJPushLogicStore

+ (void)JpushLogicStore:(NSDictionary *)userInfo {
    
    NSDictionary *data = userInfo[@"data"];
    
    NSNumber *community_id = [NSNumber numberWithInteger:[data[@"community_id"] integerValue]];
    
    NSString *community_name = data[@"community_name"];
    
    
    if ([community_id isEqualToNumber:[MHAreaManager sharedManager].community_id] && [community_name isEqualToString:[MHAreaManager sharedManager].community_name]) {
        [MHAreaManager sharedManager].status = [data[@"status"] integerValue];
        [MHAreaManager sharedManager].community_id = community_id;
        [MHAreaManager sharedManager].community_name = community_name;
        [MHAreaManager sharedManager].isJpsuh_Reload = YES ;
    }
}

@end
