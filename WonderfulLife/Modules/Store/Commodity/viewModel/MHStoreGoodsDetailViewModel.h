//
//  MHStoreGoodsDetailViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

#import "MHStoreGoodsHandler.h"

#import "MHStoreGoodsDetailModel.h"

@interface MHStoreGoodsDetailViewModel : MHBaseViewModel

//经度,当前定位出来的
@property (nonatomic,assign)double current_gps_lng;
//纬度，当前定位出来的
@property (nonatomic,assign)double current_gps_lat;

//商品ID
@property (nonatomic,assign)NSInteger coupon_id;

//列表是否正在请求
@property (nonatomic,assign)BOOL listRequesting;

@property (nonatomic,strong)MHStoreGoodsDetailModel *goodsDetailModel;


@property (nonatomic,strong,readonly)RACCommand *goodsDetailCommand;


- (void)updateLocation;

@end
