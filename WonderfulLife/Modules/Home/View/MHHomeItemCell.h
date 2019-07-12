//
//  MHHomeItemCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"


@interface MHHomeItemCell : UICollectionViewCell<MHHomeCollectionViewCellProtocol>
@property (nonatomic,weak) id<MHHomeCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mh_label;
@property (weak, nonatomic) IBOutlet UILabel *mh_subLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mh_imageView;
@end
