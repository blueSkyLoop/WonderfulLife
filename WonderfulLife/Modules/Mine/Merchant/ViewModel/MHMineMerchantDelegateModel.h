//
//  MHMineMerchantDelegateModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseCollectionDelegateModel.h"
#import "MHMineMerchantHeaderView.h"
@class MHMineMerchantDelegateModel,MHMineMerchantInfoModel;

typedef void(^infoBlcok)(MHMineMerchantDelegateModel *model);
@interface MHMineMerchantDelegateModel : MHBaseCollectionDelegateModel

@property (nonatomic, strong) MHMineMerchantHeaderView *headView;

/** 商家资料model */
@property (strong,nonatomic) MHMineMerchantInfoModel *merInfoModel;

@property (nonatomic,copy) infoBlcok block;

@end
