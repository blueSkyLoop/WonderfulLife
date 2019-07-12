//
//  MHStorePictureCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHStorePictureView.h"
#import "MHCellConfigDelegate.h"

@interface MHStorePictureCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UILabel *adescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picGapLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightLayout;
@property (weak, nonatomic) IBOutlet MHStorePictureView *pictureView;

@end
