//
//  MHVoRegisOhterMemberCell.h
//  WonderfulLife
//
//  Created by 哈马屁 on 2017/12/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVoAttendanceRecordDetailCrewModel;
@interface MHVoRegisOhterMemberCell : UITableViewCell
@property (nonatomic,strong)  MHVoAttendanceRecordDetailCrewModel *crewModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end
