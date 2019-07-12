//
//  MHVolSerReamListModel.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerReamListModel.h"
#import "MHVoSeAttendanceRegisterCell.h"
@implementation MHVolSerReamListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _commitDataModel = [MHVoSeAttendanceRegisterCommitModel new];
    }
    return self;
}
@end
