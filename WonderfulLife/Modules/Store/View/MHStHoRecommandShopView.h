//
//  MHStHoRecommandShopView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHStHoRecommandShopViewDelegate <NSObject>
- (void)shopDetailWithIndex:(NSInteger)index;
@end

@class MHStHoShopModel;
@interface MHStHoRecommandShopView : UIView
@property (nonatomic,weak) id<MHStHoRecommandShopViewDelegate> delegate;
@property (nonatomic,strong) MHStHoShopModel *shopModel;
+ (instancetype)recommandShopView;
@end
