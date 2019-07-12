//
//  MHVoAtReCoScoreFillCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHVoAtReCoScoreFillField.h"

@class MHVoAttendanceRecordDetailCrewModel;

@interface MHVoAtReCoScoreFillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MHVoAtReCoScoreFillField *scoreField;
@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *model;
@end
