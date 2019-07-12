//
//  MHStoreRecomGoodsListViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHStoreRecomGoodsListViewModel : MHBaseViewModel


@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger total_pages;
@property (nonatomic,assign)BOOL has_next;

//经度,当前定位出来的
@property (nonatomic,assign)double current_gps_lng;
//纬度，当前定位出来的
@property (nonatomic,assign)double current_gps_lat;

//列表是否正在请求
@property (nonatomic,assign)BOOL listRequesting;

@property (nonatomic,assign)NSInteger community_id;
@property (nonatomic,copy)NSString *keyWord;

//推荐商品列表
@property (nonatomic,strong,readonly)RACCommand *goodsListCommand;
//搜索商品列表
@property (nonatomic,strong,readonly)RACCommand *searchGoodListCommand;

@property (nonatomic,strong,readonly)RACSubject *UIRefreshSubject;

- (void)updateLocation;

//查询当前列表有没有这个产品，主要是用在刷新，如果当前列表没有，则无需即时刷新数据
- (BOOL)isExsitObjectWithCoupon_id:(NSInteger)coupon_id;


@end
