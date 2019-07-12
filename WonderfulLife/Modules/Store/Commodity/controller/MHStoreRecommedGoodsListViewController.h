//
//  MHStoreRecommedGoodsListViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

typedef NS_ENUM(NSInteger,MHStoreGoodsListType) {
    MHStoreGoodsList_recommed = 1, //推荐
    MHStoreGoodsList_search        //搜索
};

@interface MHStoreRecommedGoodsListViewController : MHBaseViewController

//小区ID 和 搜索关键字 type 进入的类型 推荐 搜索
- (id)initWithcommunity_id:(NSInteger)community_id keyword:(NSString *)keyWord type:(MHStoreGoodsListType)type;


@end
