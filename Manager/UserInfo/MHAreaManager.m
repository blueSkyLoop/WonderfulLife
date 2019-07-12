//
//  MHAreaManager.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAreaManager.h"
#import "MHSanboxPath.h"
#import <YYModel.h>
#import "MHAreaManager+HasAreaPermissions.h"
#import "NSObject+isNull.h"
static MHAreaManager * _manager = nil;
@interface MHAreaManager ()

@end


@implementation MHAreaManager

+ (instancetype)sharedManager {
    @synchronized (_manager) {
        if (_manager == nil) {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:PathArea];
            if (obj) {
                _manager = obj;
            } else {
                _manager = [[self alloc] init];
                _manager.community_name = @"选择小区";
                _manager.community_id = @10086;
                _manager.is_enable_mall_merchant = YES;
            }
        }
        // 在启动APP时，强制判断set 一次 YES，之后在APP不用判断,因为重置 rootViewController 的次数很频繁
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager.isSimplyFlag = YES ;
        });
    }
    return _manager;
}


- (void)setIs_infoSwitch:(BOOL)is_infoSwitch{
    _is_infoSwitch = is_infoSwitch ;
    [self saveAreaData];
}

- (void)setCommunity_id:(NSNumber *)community_id {
    _community_id = community_id ;
    [self saveAreaData];
}

- (void)setCommunity_name:(NSString *)community_name {
    _community_name = community_name ;
    [self saveAreaData];
}

- (void)setIsSimplyFlag:(BOOL)isSimplyFlag {
    _isSimplyFlag = isSimplyFlag ;
    [self saveAreaData];
}

- (void)setIs_enable_mall_merchant:(BOOL)is_enable_mall_merchant {
    _is_enable_mall_merchant = is_enable_mall_merchant ;
   [self saveAreaData];
}

- (void)setClassName:(NSString *)className {
    _className = className ;
   [self saveAreaData];
}


- (void)setIsJpsuh_Reload:(BOOL)isJpsuh_Reload{
    _isJpsuh_Reload = isJpsuh_Reload ;
    [self saveAreaData];
}


- (void)setStatus:(NSInteger)status{
    _status = status ;
    [self saveAreaData];
}


#pragma mark - 公有方法
/** 解析 */
- (void)analyzingData:(NSDictionary *)data {
    _manager = [MHAreaManager yy_modelWithJSON:data];
    [self saveAreaData];
}


/** 存档 */
- (void)saveAreaData {
    [NSKeyedArchiver archiveRootObject:_manager toFile:PathArea];
}

/** 删档 */
- (void)removeAreaData {
    _manager = nil;
    [NSKeyedArchiver archiveRootObject:_manager toFile:PathArea];
}


#pragma mark - 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self yy_modelInitWithCoder:coder];
    }
    return self;
}
- (NSString *)description {
    return [self yy_modelDescription];
}


// 取缓存地区
- (NSNumber *)getCommunityData {
    // 取缓存
    NSString *cacheCity     = [MHAreaManager sharedManager].community_name ;
    NSNumber *cacheCity_id  = [MHAreaManager sharedManager].community_id ;
    NSString *myCity        = [MHUserInfoManager sharedManager].community_name ;
    NSNumber *myCity_id     = [MHUserInfoManager sharedManager].community_id ;
    
    if (![NSObject isNull:cacheCity] && ![NSObject isNull:cacheCity_id]) { // 判断是否有缓存,有就取缓存
        return  cacheCity_id;
    }else if (![NSObject isNull:myCity] && ![NSObject isNull:myCity_id]) {  // 取已登录的 地区信息

        return  myCity_id;
    }else {
        return @10086;
    }
}

@end
