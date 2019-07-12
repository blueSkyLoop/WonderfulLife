//
//  MHStoreOrdersConsumptionViewInputController.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

@interface MHStoreOrdersConsumptionViewInputController : MHBaseViewController

//扫一扫出来的信息
/*
 order_no  string 订单号  nickname  string 下单用户昵称  phone string 下单用户手机  order_status integer
 订单状态，0待付款，1待使用，2待评价，3已完成，4退款中，5退款成功，6退款失败(待使用)，7已过期 
 */
@property (nonatomic,strong)NSDictionary *infor;

@end
