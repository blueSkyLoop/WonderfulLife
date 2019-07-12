//
//  MHReportRepairTypeViewModel.h
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHReportRepairTypeModel.h"
#import "ReactiveObjC.h"

@interface MHReportRepairTypeViewModel : NSObject
@property (nonatomic,strong) NSArray<MHReportRepairTypeModel*> *dataSource;
@property (nonatomic,strong) NSArray *subitemsDataSource;

@property (nonatomic,strong) RACSubject *refreshViewSubject;
///command
/** 
 报修类型一级接口
 */
@property (nonatomic,strong,readonly)RACCommand *repairTypeCommand;
/**
 报修类型二级接口
 */
@property (nonatomic,strong,readonly)RACCommand *repairTypeSubitemsCommand;

@end
