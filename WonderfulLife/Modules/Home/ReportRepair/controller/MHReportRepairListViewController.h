//
//  MHReportRepairListViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseViewController.h"

typedef NS_ENUM(NSInteger,ReportRepairType) {
    ReportRepair_progress,              //进行中
    ReportRepair_completed,             //已结束
    ReportRepair_evaluate               //待评价
};

@interface MHReportRepairListViewController : MHBaseViewController


@property (nonatomic,assign)ReportRepairType type;

@end
