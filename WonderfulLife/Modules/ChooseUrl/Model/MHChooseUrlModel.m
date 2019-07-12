//
//  JFRequestModel.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/6.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "MHChooseUrlModel.h"
#import "MHConstSDKConfig.h"
#import "MHNetworking.h"
#import <AFHTTPSessionManager.h>


@interface MHChooseUrlModel ()
@property (nonatomic,copy) NSString * initialChooseUrlHttpIP;
@end



@implementation MHChooseUrlModel

static NSString *baseHttpIPStr;


- (NSString *)initialChooseUrlHttpIP{

    if (MH_BUNDLEID_JFKH) {// 内部测试，从此修改默认环境，一般此处使用 ：测试环境 || 开发环境
        _initialChooseUrlHttpIP =  @"http://106.14.66.246/";

    } else if (MH_BUNDLEID_MH || MH_BUNDLEID_JF) {// 线上 || 客户体验版
        _initialChooseUrlHttpIP =  @"http://106.14.66.246/";
    }
    return _initialChooseUrlHttpIP ;
}

+(MHChooseUrlModel *)shareInstance {
    static MHChooseUrlModel *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[MHChooseUrlModel alloc] init];
    });
    return request;
}

+ (NSString *)getBaseHttpIP {
    return [[self shareInstance]getBaseHttpIP];
}

+ (void)setBaseHttpIP:(NSString *)ipStr {
    [[self shareInstance]setBaseHttpIP:ipStr];
}

// 添加配置环境地址
+ (NSArray *)requestArray {
    return @[
             @{@"name":@"正式环境",   @"ip":[NSString stringWithFormat:@"http://106.14.66.246/"]},
             @{@"name":@"汇联外网地址",   @"ip":@"http://wxcms.jufuns.cn:9026/"}
             ];
}

// 获取地址
- (NSString *)getBaseHttpIP {
    if (baseHttpIPStr == nil) {
        if (MH_BUNDLEID_JF || MH_BUNDLEID_MH) {
            baseHttpIPStr = self.initialChooseUrlHttpIP;
        } else {
            NSString *ipStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BaseHttpIP"];
            if (ipStr == nil) { // 没缓存就去默认配置
                baseHttpIPStr = self.initialChooseUrlHttpIP;
                [[NSUserDefaults standardUserDefaults] setObject:self.initialChooseUrlHttpIP forKey:@"BaseHttpIP"];
            } else {  // 有缓存就取缓存
                baseHttpIPStr = ipStr;
            }
        }
    }
    return baseHttpIPStr;
}

- (void)setBaseHttpIP:(NSString *)ipStr {
    baseHttpIPStr = ipStr;
    [[NSUserDefaults standardUserDefaults] setObject:ipStr forKey:@"BaseHttpIP"];
    [[MHNetworking shareNetworking]setupConfig];
    
}

@end
