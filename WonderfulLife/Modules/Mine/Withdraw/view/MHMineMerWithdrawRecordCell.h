//
//  MHMineMerWithdrawRecordCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHMineMerWithdrawRecordCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UILabel *appleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
