//
//  UICollectionViewCell_MHHomeCollectionView.h
//  WonderfulLife
//
//  Created by zz on 23/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"

@interface UICollectionViewCell ()
@property (nonatomic,weak) id<MHHomeCollectionViewCellDelegate> delegate;
@end
