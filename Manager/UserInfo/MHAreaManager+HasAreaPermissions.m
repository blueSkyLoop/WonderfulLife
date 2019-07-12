//
//  MHAreaManager+HasAreaPermissions.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAreaManager+HasAreaPermissions.h"

@implementation MHAreaManager (HasAreaPermissions)

- (BOOL)mh_hasAreaPermissions {
    MHAreaManager * myArea = [MHAreaManager sharedManager] ;
    NSArray *areaNames ;
#if MH_Dev
//    areaNames = @[@"体验小区",@"武汉人和天地",@"武汉名流公馆",@"武汉香域花境",@"选择小区"];
    areaNames = @[@"体验小区",@"武汉人和天地",@"选择小区"];
#elif MH_Cus
     areaNames = @[@"体验小区",@"武汉人和天地",@"选择小区"];
#elif MH_APPStore
    areaNames = @[@"体验小区",@"武汉人和天地",@"选择小区"];
#endif
    
    for (NSString *areaName in areaNames) {
        if ([myArea.community_name isEqualToString:areaName]) {
            return YES ;
        }
    }
    return NO;
}

@end
