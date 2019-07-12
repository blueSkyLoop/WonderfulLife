//
//  MHVolSeverPageViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "MHVolunteerServiceMainModel.h"
#import "MHVolSerPageFuncConstruct.h"
#import <YYModel.h>

typedef NS_ENUM(NSUInteger, volunteerRoleType) {
    volunteerRoleTypeCaptain,           //分队长
    volunteerRoleTypeLeader,            //总队长
    volunteerRoleTypeTeamMember,        //队员
    volunteerRoleTypeVirtualAccount,    //虚拟账户
};

@interface MHVolSeverPageViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *dataSoure;

@property (nonatomic,strong,readonly)RACCommand *serverCommand;

@property (nonatomic,strong,readonly)RACCommand *virtualAccountCommand;

@property (nonatomic,strong,readonly)RACCommand *attendanceRecordCommand;

@property (nonatomic,strong,readonly)RACSubject *refreshSubject;

@property (nonatomic, assign)volunteerRoleType volunteer_role;

@property (nonatomic,strong)MHVolunteerServiceMainModel *model;

@end
