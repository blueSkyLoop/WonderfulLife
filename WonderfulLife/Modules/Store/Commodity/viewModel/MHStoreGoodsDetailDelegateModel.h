//
//  MHStoreGoodsDetailDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseTableDelegateModel.h"
#import "MHStoreGoodsDetailModel.h"

@interface MHStoreGoodsDetailDelegateModel : MHBaseTableDelegateModel

@property (nonatomic,strong)UIImageView *headView;

@property (nonatomic,strong)MHStoreGoodsDetailModel *detailModel;
//点击商家
@property (nonatomic,copy)void(^merchantClikBlock)(void);

//点击封面
@property (nonatomic,copy)void(^coverPicClikBlock)(void);

@end
