//
//  MHReportRepairNewCommonCell.h
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHReportRepairNewCommonCell : UITableViewCell<MHCellConfigDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UITextField *itemContentTextField;
@property (weak, nonatomic) IBOutlet UILabel *itemContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *topSegmentLine;
@property (weak, nonatomic) IBOutlet UIView *bottomSegmentLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineRightConstraint;

@end
