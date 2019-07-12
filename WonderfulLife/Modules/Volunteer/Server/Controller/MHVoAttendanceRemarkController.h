//
//  MHVoAttendanceRemarkController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoAttendanceRemarkController : UIViewController
@property (nonatomic,copy) NSString *remarks;
@property (nonatomic,copy) void (^saveBlock)();

@end
