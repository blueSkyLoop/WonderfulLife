//
//  MHVoAttendanceRegisterModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRegisterModel.h"

@implementation MHVoAttendanceRegisterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"applied" : [MHVoAttendanceRecordDetailCrewModel class],
             @"not_apply" : [MHVoAttendanceRecordDetailCrewModel class],
             };
}
- (void)setNot_apply:(NSArray<MHVoAttendanceRecordDetailCrewModel *> *)not_apply{
    _not_apply = not_apply;
    _selected_not_apply = [NSMutableArray array];
}
@end
