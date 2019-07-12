//
//  MHCityModel.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCityModel.h"
#import "MHUserInfoManager.h"
@implementation MHCityModel
+ (instancetype)cityWithName:(NSString *)city_name {
    MHCityModel *model = [[MHCityModel alloc]init];
    model.city_name = city_name;
    return model;
}
+ (instancetype)cityModelFromUserInfo {
    MHCityModel *model = [[MHCityModel alloc]init];
    model.city_name = [MHUserInfoManager sharedManager].city.city_name;
    return model;
}
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]] &&
        [self.city_name isEqualToString:((MHCityModel *)object).city_name])
            return YES;
    return NO;
}

@end
