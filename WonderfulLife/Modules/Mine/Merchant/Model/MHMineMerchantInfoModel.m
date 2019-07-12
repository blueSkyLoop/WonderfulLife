//
//  MHMineMerchantInfoModel.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  我是商家： headerView  UI数据源显示

#import "MHMineMerchantInfoModel.h"
#import <YYModel.h>
@implementation MHMineMerchantInfoModel
static MHMineMerchantInfoModel *_instatnce;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _instatnce = [[[self class] alloc] init];
    });
    return _instatnce;
}

+ (void)clear {
    _instatnce = nil;
    onceToken  = 0;
}

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


#pragma mark -
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"my_merchant_list": [MHMineMerchantInfoModel class]
             };
}
@end
