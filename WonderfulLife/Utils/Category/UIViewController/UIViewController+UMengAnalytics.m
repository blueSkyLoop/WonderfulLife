//
//  UIViewController+UMengAnalytics.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+UMengAnalytics.h"

#import <objc/runtime.h>
#import "UMMobClick/MobClick.h"
#import "SwizzlingDefine.h"
@implementation UIViewController (UMengAnalytics)

+ (void)load {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
 
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mh_viewWillAppear:);
        swizzling_exchangeMethod(class,originalSelector,swizzledSelector);

        SEL disOriginalSelector = @selector(viewWillDisappear:);
        SEL disSwizzledSelector = @selector(mh_viewWillDisappear:);
        swizzling_exchangeMethod(class,disOriginalSelector,disSwizzledSelector);

    });
}

- (void)mh_viewWillAppear:(BOOL)animated {
    [self mh_viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)mh_viewWillDisappear:(BOOL)animated {
    [self mh_viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
@end
