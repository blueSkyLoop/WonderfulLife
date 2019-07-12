//
//  MHReportRepairListViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "MHReportRepairListViewController.h"

@interface MHReportRepairListViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,assign)ReportRepairType type;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger total_pages;
@property (nonatomic,assign)BOOL has_next;

@property (nonatomic,strong,readonly)RACSubject *UIRefreshSubject;

@property (nonatomic,strong,readonly)RACCommand *reportListCommand;
@property (nonatomic,strong,readonly)RACCommand *reportListCancelCommand;
@property (nonatomic,strong,readonly)RACCommand *reportListSolveCommand;
@property (nonatomic,strong,readonly)RACCommand *reportListEvaluateCommand;

- (BOOL)isExsitObjectWithRepairment_id:(NSInteger)repairment_id;

@end
