//
//  AppDelegate.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
// 123

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 需求、需求、需求 全局变量，生命周期跟app共存亡
 目的：成为志愿者将属性置为YES
 */
@property (nonatomic, getter=isIgnore) BOOL ignore;

/** 进入主页*/
- (void)enterMianUI;


/** 进入引导页*/
- (void)enterPageUI;
@end

