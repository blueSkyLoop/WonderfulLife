//
//  MHVolActivityListViewModel.h
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
@class MHVolActivityListDataViewModel;
@interface MHVolActivityListViewModel : NSObject

@property (strong,nonatomic) NSMutableArray<NSArray*> *dataSources;
@property (assign,nonatomic) NSInteger willUpdatePage;                   //将要更新的页数

@property (strong,nonatomic) RACSubject *attendanceRegistrationSubject;  //登记考勤
@property (strong,nonatomic) RACSubject *modifyActivitySubject;          //修改活动
@property (strong,nonatomic) RACSubject *enrollListManagerSubject;       //管理报名
@property (strong,nonatomic) RACSubject *reviewDetailSubject;            //查看详情

///Command
//------------------------- 优化请求 -----------------------------/
@property (strong,nonatomic) RACCommand *doingActivityListDatasCommand;     //进行中活动列表数据请求
@property (strong,nonatomic) RACCommand *doneActivityListDatasCommand;      //已结束活动列表数据请求
@property (strong,nonatomic) RACCommand *updateActivityListDatasCommand;    //刷新活动列表数据请求（首次进来刷新）
@property (strong,nonatomic) RACCommand *loadNewActivityListDatasCommand;   //刷新活动列表数据请求（下拉刷新）
@property (strong,nonatomic) RACCommand *loadMoreActivityListDatasCommand;  //加载活动列表更多数据请求（上拉刷新）
@property (strong,nonatomic) RACCommand *updateActivityListDatasToTopCommand;    //刷新活动列表数据请求（tableview返回顶部）

@property (strong,nonatomic) RACCommand *enrollingCommand;               //立即报名
@property (strong,nonatomic) RACCommand *enrollCancelCommand;            //取消报名
@property (strong,nonatomic) RACCommand *getMyteamsCommand;              //获取我的服务队


- (void)resetTableviewDataSource;
//遍历数据，处理数据逻辑
- (void)enumerateObjects:(NSArray*)array;
- (void)enumerateEndActivityObjects:(NSArray*)array;

- (void)assignNewPage;
- (void)resetToOldPage;


- (void)resetDoingDataSource;
- (void)resetEndDataSource;
@end
