//
//  MHStoreHomeHeaderView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/24.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHStoreHomeModel;

@protocol MHStoreHomeHeaderViewDelegate <NSObject>
- (void)didClickAddAtIndex:(NSInteger)index;
- (void)didClickButtonAtIndex:(NSInteger)index;
@end

@interface MHStoreHomeHeaderView : UIView

@property (nonatomic,strong) MHStoreHomeModel *model;
@property (nonatomic,weak) id<MHStoreHomeHeaderViewDelegate> delegate;

@end
