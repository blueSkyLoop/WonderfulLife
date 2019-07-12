//
//  MHHomeCommunityCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"

@interface MHHomeCollectionCommunityCell : UICollectionViewCell<MHHomeCollectionViewCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *mh_subject;
@property (weak, nonatomic) IBOutlet UILabel *mh_timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mh_imageView;
@property (weak,nonatomic) id <MHHomeCollectionViewCellDelegate> delegate;

@end
