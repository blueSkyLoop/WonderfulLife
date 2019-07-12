//
//  MHStoreGoodsDetailViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

@interface MHStoreGoodsDetailViewController : MHBaseViewController

@property (nonatomic,assign)NSInteger coupon_id;

- (id)initWithCoupon_id:(NSInteger)coupon_id;

@end
