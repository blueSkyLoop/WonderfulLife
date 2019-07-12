//
//  MHReportRepairListModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHReportRepairListModel : NSObject
//报修类型名称
@property (nonatomic,copy)NSString *repairment_category_name;
//报修内容
@property (nonatomic,copy)NSString *repairment_cont;
//报修单状态.0：待处理，1：处理中，2：已完成，3：已取消 4:已激活
@property (nonatomic,assign)NSInteger repairment_status;
//时间：刚刚，1分钟钱，1天前，100天前
@property (nonatomic,copy)NSString *times;
//是否显示取消按钮，0不显示，1显示
@property (nonatomic,assign)NSInteger is_show_cancel;
//是否显示评价按钮，0不显示，1显示
@property (nonatomic,assign)NSInteger is_show_evaluate;
//是否显示仍未解决按钮，0不显示，1显示
@property (nonatomic,assign)NSInteger is_show_activate;
//报修单id
@property (nonatomic,assign)NSInteger repairment_id;
//报修单状态名字.0：待处理，1：处理中，2：已完成，3：已取消 4:待处理（已激活之后就是处于待处理状态）
@property (nonatomic,copy)NSString *repairment_status_name;
//0:报修类型，1：投诉类型
@property (nonatomic,assign)NSInteger repair_type;

//根据状态获取状态字符颜色
- (UIColor *)statusUIColor;

@end
