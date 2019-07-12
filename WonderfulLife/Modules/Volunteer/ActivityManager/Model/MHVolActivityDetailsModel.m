//
//  MHVolActivityDetailsModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsModel.h"
#import "MHVolSerCaptainModel.h"
@implementation MHVolActivityDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"captain" : NSClassFromString(@"MHVolSerCaptainModel"),
             @"team_member_list" : NSClassFromString(@"MHVolSerTeamMember") };
}


+ (MHVolActivityDetailsModel *)model{
    MHVolActivityDetailsModel *model = [MHVolActivityDetailsModel new];
    
    model.title = @"治安巡逻";
    model.team_name = @"武汉治安巡逻队";
    
    MHVolSerCaptainModel *captain = [MHVolSerCaptainModel new];
    captain.captain_name = @"朱大哥";
    
    model.captain = captain ;
    
    model.rule = @"负责武汉人和天地太和园，伈和园的日常治安巡逻，保证园区的日常秩序正常进行，处理紧急事务，为每位社区业主提";
    model.intro = @"qwertyuiopqowieuoqwpueoqwuieoqwueioqwueopqwueopqwiueoqpwueopqwueopduopasudoasudopasudopasudoauspdasduoasudpoasudpoopudoaisudoau";
    
    model.addr = @"中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际中泰国际";
    model.team_member_list =@[@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123"];
    model.isOpenIntro = NO;
    model.isOpenRules = NO;
    return model;
}

@end
