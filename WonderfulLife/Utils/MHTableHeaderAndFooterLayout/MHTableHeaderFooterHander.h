//
//  MHTableHeaderFooterHander.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* 数据刷新的回调 mhTableHeadFootView 为创建时传过来的view也就是最终加载的view*/
typedef void (^MHTableHeadFootRefreshDataBlock)(id mhTableHeadFootView);

@interface MHTableHeaderFooterHander : NSObject

/** 数据刷新的回调 */
@property (copy, nonatomic) MHTableHeadFootRefreshDataBlock refrehBlock;
/** 回调对象 */
@property (weak, nonatomic) id refreshTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshAction;

@property (nonatomic,readonly,weak)UIView *tableHeaderFooterView;
@property (nonatomic,readonly,weak)UITableView *tableView;

/** 创建headerView 执行者 headView为最终要加载到tableView的tableHeaderView*/
+ (instancetype)mh_tableHeaderViewWithView:(UIView *)headerView refresBlock:(MHTableHeadFootRefreshDataBlock)refresBlock;
/** 创建headerView 执行者 headView为最终要加载到tableView的tableHeaderView 其中action不能携带参数*/
+ (instancetype)mh_tableHeaderViewWithView:(UIView *)headerView target:(id)target refrehAction:(SEL)action;

/** 创建footerView 执行者 footerView为最终要加载到tableView的tableFooterView*/
+ (instancetype)mh_tableFooterViewWithView:(UIView *)footerView refresBlock:(MHTableHeadFootRefreshDataBlock)refresBlock;
/** 创建footerView 执行者 footerView为最终要加载到tableView的tableFooterView 其中action不能携带参数*/
+ (instancetype)mh_tableFooterViewWithView:(UIView *)footerView target:(id)target refrehAction:(SEL)action;

/*刷新数据*/
- (void)mh_refreshData;

/*初始设置tableHeadView 或者tableFootView 时执行*/
- (void)mh_initHeaderOrFooterViewWithTableView:(UITableView *)tableView;

@end
