//
//  MHVoAtReDaySiftController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVoAttendanceRecordSiftModel;


@interface MHVoAtReDaySiftController : UIViewController
@property (nonatomic,strong) MHVoAttendanceRecordSiftModel *siftModel;
@property (nonatomic,copy) void (^beginSift)();
@end
