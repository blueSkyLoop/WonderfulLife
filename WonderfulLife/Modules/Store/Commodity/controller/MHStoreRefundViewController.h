//
//  MHStoreRefundViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "MHMerchantOrderDetailModel.h"

@interface MHStoreRefundViewController : MHBaseViewController
@property (nonatomic,strong)MHMerchantOrderDetailModel *orderDetailModel;

- (id)initWithOrderDetailModel:(MHMerchantOrderDetailModel *)orderDetailModel;

@end
