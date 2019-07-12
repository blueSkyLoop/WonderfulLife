//
//  MHAttendanceRecordSectionHeader.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHAttendanceRecordSectionHeaderTypeList, //间距18，字体16,不缩放
    MHAttendanceRecordSectionHeaderTypeListMonth, //间距24，字体16，缩放
    MHAttendanceRecordSectionHeaderTypeDetail, //间距24，字体20，缩放
    MHAttendanceRecordSectionHeaderTypePeople, //间距24，字体20，缩放，有数量,
    MHAttendanceRecordSectionHeaderTypeReject, //间距24，字体20，缩放, 红色
    MHAttendanceRecordSectionHeaderTypeOtherMember,
} MHAttendanceRecordSectionHeaderType;

@protocol MHAttendanceRecordSectionHeaderDelegate <NSObject>
- (void)sectionHeaderDidClick;
@end

@interface MHAttendanceRecordSectionHeader : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,assign) MHAttendanceRecordSectionHeaderType type;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,weak) id <MHAttendanceRecordSectionHeaderDelegate> delegate;


@end
