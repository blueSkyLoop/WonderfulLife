//
//  MHVoAttendanceRecordSiftModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVoAttendanceRecordSiftModel : NSObject
@property (nonatomic,copy) NSString *requestDateBegin;
@property (nonatomic,copy) NSString *requestDateEnd;

@property (nonatomic,copy) NSString *showDateBegin;
@property (nonatomic,copy) NSString *showDateEnd;

@property (nonatomic,strong) NSNumber *year;
@property (nonatomic,strong) NSNumber *month;
/** -1:全部状态
 0:待审核
 1:审核通过
 2:审核不通过 */
@property (nonatomic,assign) long attendance_status;

@end
