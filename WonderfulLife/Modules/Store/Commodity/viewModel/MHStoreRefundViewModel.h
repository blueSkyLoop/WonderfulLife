//
//  MHStoreRefundViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"
#import "MHStoreRefundReasonModel.h"
#import "MHMerchantOrderDetailModel.h"

@interface MHStoreRefundViewModel : MHBaseViewModel
//选中的退款理由
@property (nonatomic,copy)NSArray *selectReaseArr;
//是否改变过
@property (nonatomic,assign)BOOL isChanged;

@property (nonatomic,strong)MHMerchantOrderDetailModel *detailModel;

//退款说明
@property (nonatomic,copy)NSString *reamrk;

//订单号
@property (nonatomic,copy)NSString *order_no;

//订单退款理由
@property (nonatomic,strong,readonly)RACCommand *refundReasonListCommand;
//买家-申请退款
@property (nonatomic,strong,readonly)RACCommand *appleRefundCommand;

@end
