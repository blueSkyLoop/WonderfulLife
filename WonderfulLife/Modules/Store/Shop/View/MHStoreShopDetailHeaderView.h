//
//  MHStoreShopDetailHeaderView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/26.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHStoShopDetailModel;
@protocol MHStoreShopDetailHeaderViewDelegate <NSObject>

- (void)phoneCall;
@end


@interface MHStoreShopDetailHeaderView : UIView
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) MHStoShopDetailModel *model;
+ (instancetype)headerView;
@property (nonatomic,weak) id<MHStoreShopDetailHeaderViewDelegate> delegate;

@end
