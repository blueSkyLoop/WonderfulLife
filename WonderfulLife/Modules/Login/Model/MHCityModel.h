//
//  MHCityModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHCityModel : NSObject
/// <#summary#>
@property (copy,nonatomic) NSString *city_name;

+ (instancetype)cityWithName:(NSString *)city_name;

+ (instancetype)cityModelFromUserInfo;

@end
