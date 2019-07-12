//
//  MHMineMerWithdrawFinanceRecordCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHMineMerWithdrawFinanceRecordCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UILabel *scroreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
