//
//  MHHomeCricleCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeCricleCell.h"
#import <SDCycleScrollView.h>
#import "MHHomeBannerAd.h"
#import "Masonry.h"
@interface MHHomeCricleCell()<SDCycleScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;

@property (strong, nonatomic) SDCycleScrollView *scrollView;


@property (weak, nonatomic) UIView *scContentView;
@end

@implementation MHHomeCricleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
 //   self.scrollView.delegate = self;
 //   self.scrollView.showPageControl = YES;
 //   self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
  //  self.scrollView.pageControlDotSize = CGSizeMake(6, 6);
  //  self.scrollView.currentPageDotColor = [UIColor whiteColor];
 //   self.scrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
 //   self.scrollView.autoScrollTimeInterval = 3;
    
}

- (void)refreshWithBannerList:(NSArray<MHHomeBannerAd *>*)bannerList {
//    NSMutableArray *urlArr = [NSMutableArray array];
//    for (MHHomeBannerAd *bannerAd in [bannerList copy]) {
//        if (bannerAd.img_url) [urlArr addObject:bannerAd.img_url];
//    }
//    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:urlArr];
//    self.scrollView.layer.cornerRadius = 6;
//    self.scrollView.layer.masksToBounds = YES;
//    
//    [self.contentView addSubview:self.scrollView];
//    
//    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(8);
//        make.left.equalTo(self.contentView).offset(16);
//        make.right.equalTo(self.contentView).offset(-16);
//        make.bottom.equalTo(self.contentView).offset(0);
//    }];
//    
//    self.scrollView.delegate = self;
//    self.scrollView.showPageControl = YES;
//    self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    self.scrollView.pageControlDotSize = CGSizeMake(6, 6);
//    self.scrollView.currentPageDotColor = [UIColor whiteColor];
//    self.scrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
//    self.scrollView.autoScrollTimeInterval = 4;
    
//    CGRect  scrollViewFrame = self.scContentView.frame ;
//    self.contentView.layer.cornerRadius = scrollViewFrame.size.width*0.05  ;
//    self.contentView.layer.masksToBounds = YES ;
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    // 回调url 到 headerView 
    if([self.delegate respondsToSelector:@selector(mh_collectionViewCell:didSelectedAdsItemAtIndex:)]) {
        [self.delegate mh_collectionViewCell:self didSelectedAdsItemAtIndex:index];
    }
}

- (void)mh_collectionViewCellWithModel:(NSArray<MHHomeBannerAd *>*)bannerList {
    NSMutableArray *urlArr = [NSMutableArray array];
    for (MHHomeBannerAd *bannerAd in [bannerList copy]) {
        if (bannerAd.img_url) [urlArr addObject:bannerAd.img_url];
    }
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:urlArr];
    self.scrollView.layer.cornerRadius = 6;
    self.scrollView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.scrollView];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
    
    self.scrollView.delegate = self;
    self.scrollView.showPageControl = YES;
    self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.scrollView.pageControlDotSize = CGSizeMake(6, 6);
    self.scrollView.currentPageDotColor = [UIColor whiteColor];
    self.scrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
    self.scrollView.autoScrollTimeInterval = 4;

}

@end
