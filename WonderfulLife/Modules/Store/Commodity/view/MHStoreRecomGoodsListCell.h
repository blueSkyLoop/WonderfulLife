//
//  MHStoreRecomGoodsListCell.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCellConfigDelegate.h"

#import "MHStoreRecomGoodsListModel.h"
@class MHStoreSearchGoodsModel;
@interface MHStoreRecomGoodsListCell : UITableViewCell<MHCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *distanceBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *merchantNameRightLayout;

//赋值
- (void)mh_configCellWithInfor:(MHStoreRecomGoodsListModel *)model;

@property (nonatomic,strong) MHStoreSearchGoodsModel *searchModel;

@end
