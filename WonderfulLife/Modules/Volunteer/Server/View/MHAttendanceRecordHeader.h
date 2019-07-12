//
//  MHAttendanceRecordHeader.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHAttendanceRecordHeaderTypeAttendanceDetail,
    MHAttendanceRecordHeaderTypeRegisterAttendance,
    MHAttendanceRecordHeaderTypeChooseTeam
} MHAttendanceRecordHeaderType;

@interface MHAttendanceRecordHeader : UIView
@property (nonatomic,assign) MHAttendanceRecordHeaderType type;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,copy) NSString *title;

- (void)scrollTitleLabelWithScrollView:(UIScrollView *)scrollView;
@end
