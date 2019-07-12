//
//  MHStoreGoodsDetailBottomView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"
#import "MHStoreGoodsDetailModel.h"

@interface MHStoreGoodsDetailBottomView : UIView

@property (nonatomic,strong)UILabel *priceLable;
@property (nonatomic,strong)UILabel *doorPriceLable;
@property (nonatomic,strong)MHThemeButton *buyButton;

- (void)configBottomViewWithModel:(MHStoreGoodsDetailModel *)model;


@end
