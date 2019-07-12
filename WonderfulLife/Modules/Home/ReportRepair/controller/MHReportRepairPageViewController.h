//
//  MHReportRepairPageViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHReportRepairListViewController.h"

@protocol ReportRepairMainPageDelegate <NSObject>

- (void)scrollCompleWithIndex:(NSInteger)index currentController:(UIViewController *)controller;

@end

@interface MHReportRepairPageViewController : UIPageViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,weak)id<ReportRepairMainPageDelegate>scrollDelegate;
@property (nonatomic,strong)NSMutableArray <MHReportRepairListViewController *>*pageControllers;


- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
