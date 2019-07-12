//
//  MHReportRepairPictreCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"
#import "MHReportRepairPictureView.h"

@interface MHReportRepairPictreCell : UICollectionViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic,copy)void(^pictureCloseBlock)(MHReportRepairPictureModel *amodel);

@end
