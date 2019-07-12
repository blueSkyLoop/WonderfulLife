//
//  MHVoAttendanceRecordDetailModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordDetailModel.h"
#import "NSString+Utils.h"

@implementation MHVoAttendanceRecordDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"applied_crews" : [MHVoAttendanceRecordDetailCrewModel class],
             @"not_apply_crews" : [MHVoAttendanceRecordDetailCrewModel class],
             @"imgs" : [MHOOSImageModel class]
              };
}

@end

@implementation MHVoAttendanceRecordDetailCrewModel{
    BOOL interesting;
}

-(void)setDuration:(NSString *)duration{
    _duration = duration;
    if (interesting == NO) {
        _orginDuration = [duration mutableCopy];
        interesting = YES;
    }
}

- (void)setVolunteer_name:(NSString *)volunteer_name{
    _volunteer_name = volunteer_name;
    _pinyin = volunteer_name.pinyin;
}

@end




