//
//  MHReportRepairListCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHReportRepairListModel.h"

@interface MHReportRepairListCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *firtButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

//index  1 取消   2 去评价  3 仍未解决
@property (nonatomic,copy)void(^cellClikBlock)(UIButton *btn,NSInteger index,MHReportRepairListModel *model);

@end
