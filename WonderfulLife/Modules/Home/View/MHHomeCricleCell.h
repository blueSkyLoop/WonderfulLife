//
//  MHHomeCricleCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"

@class SDCycleScrollView,MHHomeBannerAd,MHHomeCricleCell;
@protocol MHHomeCricleCellDelegate <NSObject>
@optional

- (void)didSelectHomeCricleCell:(NSInteger)index;

@end


@interface MHHomeCricleCell : UICollectionViewCell<MHHomeCollectionViewCellProtocol>

@property (nonatomic,weak) id<MHHomeCollectionViewCellDelegate> delegate;

- (void)refreshWithBannerList:(NSArray<MHHomeBannerAd *>*)bannerList;


@end
