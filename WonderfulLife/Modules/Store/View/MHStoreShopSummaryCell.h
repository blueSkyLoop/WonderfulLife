//
//  MHStoreShopSummaryCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHStoShopDetailModel,MHStoShopSummaryModel;
@interface MHStoreShopSummaryCell : UITableViewCell
@property (nonatomic,strong) MHStoShopDetailModel *shopModel;
@property (nonatomic,strong) MHStoShopSummaryModel *summaryModel;
@end
