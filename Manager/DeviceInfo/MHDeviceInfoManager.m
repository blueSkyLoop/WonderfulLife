//
//  MHDeviceInfoManager.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHDeviceInfoManager.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#import "SSKeychain.h"

@implementation MHDeviceInfoManager
+ (NSString*)deviceUUIDString {
    //这可以保证这个app获取的UUID永远都是同一个, 卸载了也会是同一个，除非重刷机或者恢复出厂设置
    NSString *service_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"WonderfulLifeUUID"];
    if(!service_id){
        service_id = [SSKeychain passwordForService:@"WonderfulLifeUUID" account:@"WonderfulLife"];
        [[NSUserDefaults standardUserDefaults] setValue:service_id forKey:@"WonderfulLifeUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(!service_id){
        service_id = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        [[NSUserDefaults standardUserDefaults] setValue:service_id forKey:@"WonderfulLifeUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SSKeychain setPassword:service_id forService:@"WonderfulLifeUUID" account:@"WonderfulLife"];
    }
    return service_id;
}

+ (NSString *)deviceSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}


+ (NSString *)deviceVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //未考虑iPhone3等较老设备，未考虑iPad设备
    if ([deviceString hasPrefix:@"iPhone3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString hasPrefix:@"iPhone6"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"]||[deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"]||[deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"i386"]||[deviceString isEqualToString:@"x86_64"])         return @"Simulator";
    //如果没有匹配直接返回系统提供的类似@iPhone5,3这种型号
    return deviceString;
}

+ (NSString *)appVersion {
   return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSDictionary *)getDeviceInfos {
    return @{@"service_id" : [self deviceUUIDString] ? [self deviceUUIDString] : [NSNull null],
             @"os_v" : [self deviceSystemVersion] ? [self deviceSystemVersion] : [NSNull null],
             @"service_no" : [self deviceVersion] ? [self deviceVersion] : [NSNull null],
             @"app_v" : [self appVersion] ? [self appVersion] : [NSNull null]};
}

@end
