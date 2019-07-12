//
//  MHActivityModifyBaseViewModel.h
//  WonderfulLife
//
//  Created by zz on 15/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface MHActivityModifyBaseViewModel : NSObject

/**
 拉取显示数据|拉取发布活动模板
 */
@property (strong, nonatomic) RACCommand *pullDisplayDatasCommand;
/**
 更新修改活动资料|发布活动
 */
@property (strong, nonatomic) RACCommand *updateModifyDatasCommand;
/**
 提交的修改数据|提交新的活动数据
 */
@property (strong,nonatomic)NSMutableDictionary *postDatas;
/**
 刷新tableview界面
 */
@property (strong, nonatomic) RACSubject *reloadDataSubject;
/**
 修改活动介绍跳转
 */
@property (strong, nonatomic) RACSubject *modifyIntroduceSubject;
/**
 修改活动规则跳转
 */
@property (strong, nonatomic) RACSubject *modifyRulesSubject;
/**
 修改活动人数
 */
@property (strong, nonatomic) RACSubject *modifyPeoplesSubject;
/**
 修改活动人数
 */
@property (assign, nonatomic) NSInteger modifyPeoples;
/**
 tableview 数据源
 */
@property (strong, nonatomic) NSMutableArray *dataSources;
/**
 活动标题
 */
@property (copy, nonatomic) NSString   *activityTitle;
/**
 活动介绍
 */
@property (copy, nonatomic) NSString   *activityIntroduce;
/**
 活动规则
 */
@property (copy, nonatomic) NSString   *activityRule;
/**
 绑定的control
 */
@property (weak, nonatomic) UIViewController *controller;

/**
 服务队id
 */
@property (strong,nonatomic) NSNumber  *vol_team_id;
/**
 服务队名称
 */
@property (copy  ,nonatomic) NSString  *vol_team_name;
/**
 活动模板id
 */
@property (strong,nonatomic) NSNumber  *activity_template_id;
/**
 活动ID
 */
@property (strong,nonatomic) NSNumber  *action_id;

/**
 活动teamID
 */
@property (strong,nonatomic) NSNumber  *activity_team_id;


/**
 tableview 点击 cell 事件
 
 @param indexPath cell 的 indexPath
 */
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
