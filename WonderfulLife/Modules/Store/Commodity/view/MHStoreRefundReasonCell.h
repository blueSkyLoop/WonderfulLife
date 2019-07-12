//
//  MHStoreRefundReasonCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHStoreRefundReasonCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
