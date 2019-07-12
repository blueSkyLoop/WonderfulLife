//
//  MHStoreOrdersConsumptionViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHStoreOrdersConsumptionViewModel : MHBaseViewModel

//订单号
@property (nonatomic,copy)NSString *order_no;

//订单消费，订单详情
@property (nonatomic,strong,readonly)RACCommand *orderDetailCommand;

//订单消费
@property (nonatomic,strong,readonly)RACCommand *orderCostCommand;

@end
