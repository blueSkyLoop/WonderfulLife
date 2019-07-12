//
//  MHReportRepairNewViewModel.h
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface MHReportRepairNewViewModel : NSObject

@property (nonatomic,copy) NSString *controllerTitle;

@property (nonatomic,assign) BOOL isEnableSubmit;
@property (nonatomic,strong,readonly)NSMutableArray *dataSource;
///Subject
@property (nonatomic,strong,readonly)RACSubject *refreshViewSubject;
///Command
@property (nonatomic,strong,readonly)RACCommand *reportNewCommand;
@property (nonatomic,strong,readonly)RACCommand *reportNewGetRoomInfoCommand;

- (void)submitRepairInfo;

@end
