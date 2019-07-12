//
//  MHHomeVolunteerCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"

@interface MHHomeVolunteerCell : UICollectionViewCell<MHHomeCollectionViewCellProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *mh_imageView;
@property (weak, nonatomic) IBOutlet UILabel *mh_content;
@property (weak,nonatomic) id <MHHomeCollectionViewCellDelegate> delegate;
@end
