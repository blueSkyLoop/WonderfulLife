//
//  MHReportRepairDetailProgressCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

#import "YYLabel.h"

@interface MHReportRepairLineView : UIImageView
@end

@interface MHReportRepairDetailProgressCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *progressIconView;
@property (weak, nonatomic) IBOutlet MHReportRepairLineView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet YYLabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapLayoutTel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapLayoutRemark;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthLayout;

@end
