//
//  MHReportRepairDetailModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MHReportRepairInforModel : NSObject
//
@property (nonatomic,assign)CGFloat height;
//
@property (nonatomic,copy)NSString *s_url;
//
@property (nonatomic,copy)NSString *url;
//
@property (nonatomic,assign)CGFloat width;
@end

@interface MHReportRepairLogModel : NSObject

//日志时间
@property (nonatomic,copy)NSString *create_datetime_str;
//日志标题
@property (nonatomic,copy)NSString *operation_app;
//日志备注
@property (nonatomic,copy)NSString *remarks;
//日志id
@property (nonatomic,assign)NSInteger repairment_log_id;
//手机号码
@property (nonatomic,copy)NSString *contact_phone;

//自己添加
@property (nonatomic,assign)BOOL isFirst;


@end

@interface MHReportRepairCategoryModel : NSObject

//深度
@property (nonatomic,assign)NSInteger depth;
//父类id
@property (nonatomic,assign)NSInteger parent_id;
//类型Id
@property (nonatomic,assign)NSInteger repairment_category_id;
//类型名称
@property (nonatomic,copy)NSString *repairment_category_name;

@end

@interface MHReportRepairDetailModel : NSObject

//大类-小类
@property (nonatomic,copy)NSString *category_name;
//联系人
@property (nonatomic,copy)NSString *contact_man;
//电话号码
@property (nonatomic,copy)NSString *contact_tel;
//评价内容，is_evaluate=0时为null
@property (nonatomic,copy)NSString *evaluate_cont;
//评价星级，is_evaluate=0时为null
@property (nonatomic,assign)NSInteger evaluate_level;
//
@property (nonatomic,copy)NSArray <MHReportRepairInforModel *> *img_info_dtos;
//是否评价,0|1
@property (nonatomic,assign)NSInteger is_evaluate;
//
@property (nonatomic,copy)NSArray <MHReportRepairLogModel *> *repair_log_app_vos;
//
@property (nonatomic,copy)NSArray <MHReportRepairCategoryModel *> *repairment_category_vos;
//投诉报修内容
@property (nonatomic,copy)NSString *repairment_cont;
//投诉报修id
@property (nonatomic,assign)NSInteger repairment_id;
//房间信息
@property (nonatomic,copy)NSString *room;
//状态枚举值
@property (nonatomic,assign)NSInteger status;
//状态名字
@property (nonatomic,copy)NSString *status_name;
//0:报修类型，1：投诉类型
@property (nonatomic,assign)NSInteger repair_type;


@end
