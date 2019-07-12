//
//  MHStHoRecommandGoodsView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHStHoRecommandGoodsViewDelegate <NSObject>
- (void)goodsDetailWithIndex:(NSInteger)index;
@end


@class MHStHomeGoodsModel;
@interface MHStHoRecommandGoodsView : UIView
@property (nonatomic,strong) MHStHomeGoodsModel *goodsModel;

@property (nonatomic,weak) id<MHStHoRecommandGoodsViewDelegate> delegate;

+ (instancetype)recommandGoodsView;
@end
