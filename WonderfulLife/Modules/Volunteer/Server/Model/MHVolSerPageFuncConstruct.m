//
//  MHVolSerPageFuncConstruct.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerPageFuncConstruct.h"
#import "MHVolunteerServiceMainModel.h"

@implementation MHVolSerPageFuncConstruct
+ (NSArray *)volSerPageFuncConstructWithMainModel:(MHVolunteerServiceMainModel *)model {
   
    MHVoServerFunctiomModel *model_0 = [[MHVoServerFunctiomModel alloc] init];
    model_0.title = @"服务队";
    model_0.imageName = @"vo_home_teams";
    model_0.type = SeverPage_team;
    
    MHVoServerFunctiomModel *model_1 = [[MHVoServerFunctiomModel alloc] init];
    model_1.title = @"服务项目";
    model_1.imageName = @"vo_home_project";
    model_1.type = SeverPage_project;
    
    MHVoServerFunctiomModel *model_2 = [[MHVoServerFunctiomModel alloc] init];
    model_2.title = @"积分明细";
    model_2.imageName = @"vo_home_score";
    model_2.type = SeverPage_integralDetail;
    
    MHVoServerFunctiomModel *model_3 = [[MHVoServerFunctiomModel alloc] init];
    model_3.title = @"服务时长";
    model_3.imageName = @"vo_home_time";
    model_3.type = SeverPage_time;
    
    MHVoServerFunctiomModel *model_4 = [[MHVoServerFunctiomModel alloc] init];
    model_4.title = @"考勤记录";
    model_4.imageName = @"vo_home_attendance";
    model_4.type = SeverPage_attendanceRecord;
    
    MHVoServerFunctiomModel *model_5 = [[MHVoServerFunctiomModel alloc] init];
    model_5.title = @"人员审核";
    model_5.imageName = @"vo_home_verification";
    model_5.type = SeverPage_verification;
    
    ///新增资料卡按钮
    MHVoServerFunctiomModel *model_6 = [[MHVoServerFunctiomModel alloc] init];
    model_6.title = @"资料卡";
    model_6.imageName = @"vo_home_infocard";
    model_6.type = SeverPage_informationCard;
    
    NSArray *array = nil;
    if (model.role.integerValue == 0) {
        array = @[model_0, model_1, model_6, model_2, model_3,model_4];
    } else if (model.role.integerValue == 1) {
        if ([model.is_promise_approve isEqualToNumber:@1]) {
            array = @[model_0, model_1, model_6, model_2, model_3,model_4, model_5];
        } else {
            array = @[model_0, model_1, model_6, model_2, model_3,model_4];
        }
    } else if (model.role.integerValue == 9) {
        array = @[model_0, model_1, model_6, model_2, model_3,model_4, model_5];
    } else if (model.role.integerValue == 2){
        array = @[model_2, model_3];
    }
    return array;
}

+ (NSArray *)virtualAccountFuncConstruct {
    

    MHVoServerFunctiomModel *model_2 = [[MHVoServerFunctiomModel alloc] init];
    model_2.title = @"积分明细";
    model_2.imageName = @"vo_home_score";
    
    MHVoServerFunctiomModel *model_3 = [[MHVoServerFunctiomModel alloc] init];
    model_3.title = @"服务时长";
    model_3.imageName = @"vo_home_time";
    
    return @[model_2, model_3];
}


@end

@implementation MHVoServerFunctiomModel

@end
