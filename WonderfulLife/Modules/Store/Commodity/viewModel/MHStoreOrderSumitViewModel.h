//
//  MHStoreOrderSumitViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

#import "MHStoreGoodsOrderDetailModel.h"

#import "MHStoreGoodsDetailModel.h"

@interface MHStoreOrderSumitViewModel : MHBaseViewModel

//商品ID
@property (nonatomic,assign)NSInteger coupon_id;

//订单号列表
@property (nonatomic,copy)NSArray *orderNoList;

//总共要支付的积分
@property (nonatomic,copy)NSString *totalScore;

//接口暂不开发，暂无数据
@property (nonatomic,strong)MHStoreGoodsOrderDetailModel *orderModel;

//从详情传过来的数据模型
@property (nonatomic,strong)MHStoreGoodsDetailModel *detailModel;

//商品查询，库存量之类的(此接口暂不开发)
@property (nonatomic,strong,readonly)RACCommand *goodsQueryCommand;

//提交订单
@property (nonatomic,strong,readonly)RACCommand *goodsSubmitCommand;


@end
