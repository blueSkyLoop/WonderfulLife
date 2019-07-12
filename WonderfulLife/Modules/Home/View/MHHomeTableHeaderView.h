//
//  MHHomeTableHeaderView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHHomeTableHeaderViewDelegate <NSObject>
- (void)didSelectTenementItem:(NSDictionary *)dic;
- (void)didSelectBannerItem:(NSInteger)item;
- (void)didSelectFacilityItem:(NSInteger)item;
@end

@class MHHomeBannerAd;
@interface MHHomeTableHeaderView : UICollectionView
- (void)refreshWithBannerList:(NSArray<MHHomeBannerAd *>*)bannerList;
@property (weak,nonatomic) id<MHHomeTableHeaderViewDelegate> customDelegate;
@end
