//
//  MHUserInfoManager.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHUserInfoManager.h"
#import "NSObject+isNull.h"

#import "MHConst.h"
#import "MHSanboxPath.h"

#import <YYModel.h>

static MHUserInfoManager * _manager = nil;

@implementation MHUserInfoManager
+ (instancetype)sharedManager {
    @synchronized (_manager) {
        if (_manager == nil) {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:PathUserInfo];
            if (obj) {
                _manager = obj;
            } else {
                _manager = [[self alloc] init];
            }
        }
    }
    return _manager;
}

#pragma mark - 公有方法
/** 解析 */
- (void)analyzingData:(NSDictionary *)data {
    _manager = [MHUserInfoManager yy_modelWithDictionary:data];
    [self saveUserInfoData];
    
    //存token
    NSString *token = data[@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kTokenKey];
    
    //存登录帐号
    [[NSUserDefaults standardUserDefaults] setObject:_manager.phone_number forKey:kAccount];
}

/** 存档 */
- (void)saveUserInfoData {
    [NSKeyedArchiver archiveRootObject:_manager toFile:PathUserInfo];
}

/** 删档 */
- (void)removeUserInfoData {
    _manager = nil;
    [NSKeyedArchiver archiveRootObject:_manager toFile:PathUserInfo];
    
    //删token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenKey];
}

#pragma mark - 业务逻辑
- (BOOL)isLogin {
   NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (token) {
        return YES;
    }
    return NO;
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

#pragma mark -
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"province": [MHProvince class],
             @"city": [MHCity class],
             @"nativeprovince": [MHNativeprovince class],
             @"nativecity": [MHNativecity class],
             @"role": [MHUserRole class],
             @"volUserInfo": [MHVolUserInfo class]
             };
}
@end


@implementation MHUserRole
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
@end

//-------------------------地理信息-----------------------------/
@implementation MHProvince
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
@end

@implementation MHCity
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
@end

@implementation MHNativeprovince
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
@end

@implementation MHNativecity
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
@end

@implementation MHVolUserInfo
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

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"address":[MHVolUserInfoAddress class]
             };
}
@end

@implementation MHVolUserInfoAddress

@end
