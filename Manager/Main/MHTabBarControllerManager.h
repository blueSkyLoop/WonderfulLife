//
//  XXTabBarControllerManager.h
//  BaseFramework
//
//  Created by Mantis-man on 16/1/16.
//  Copyright © 2016年 Mantis-man. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHNavigationControllerManager;
@interface MHTabBarControllerManager : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray  *mutabControllers;

/** 首页 */
@property (strong,nonatomic) MHNavigationControllerManager *home;

/** 志愿者 */
@property (strong,nonatomic) MHNavigationControllerManager *volunteer;

/** 商城 */
@property (strong,nonatomic) MHNavigationControllerManager *store;

/** 我的 */
@property (strong,nonatomic) MHNavigationControllerManager *mine;


+ (MHTabBarControllerManager *)getMHTabbar;

//- (void)reloadChildControllers ;

@end
