//
//  MHVolSerPageFuncConstruct.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHVolunteerServiceMainModel;

typedef NS_ENUM(NSInteger,MHVolSeverPageType) {
    SeverPage_team = 1,                     //服务队
    SeverPage_project,                      //服务项目
    SeverPage_integralDetail,               //积分明细
    SeverPage_time,                         //服务时长
    SeverPage_attendanceRecord,             //考勤记录
    SeverPage_verification,                 //人员审核
    SeverPage_informationCard               //资料卡
    
};

@interface MHVolSerPageFuncConstruct : NSObject
+ (NSArray *)volSerPageFuncConstructWithMainModel:(MHVolunteerServiceMainModel *)model;
//虚拟账户显示的数组
+ (NSArray *)virtualAccountFuncConstruct;
@end

@interface MHVoServerFunctiomModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) MHVolSeverPageType type;
@end
