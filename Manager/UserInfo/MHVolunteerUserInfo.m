//
//  MHVolunteerUserInfo.m
//  WonderfulLife
//
//  Created by zz on 18/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerUserInfo.h"
#import <YYModel.h>

static MHVolunteerUserInfo *_instatnce;
static dispatch_once_t onceToken;

@implementation MHVolunteerUserInfo

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

//------------------------- YYModel -----------------------------/

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
    return @{ @"address":[MHVolunteerUserInfoAddress class]
              };
}

@end

@implementation MHVolunteerUserInfoAddress



@end
