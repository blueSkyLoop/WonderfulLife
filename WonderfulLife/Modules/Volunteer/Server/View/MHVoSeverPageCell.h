//
//  MHVoSeverPageCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

@interface MHVoSeverPageCell : UICollectionViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;



@end
