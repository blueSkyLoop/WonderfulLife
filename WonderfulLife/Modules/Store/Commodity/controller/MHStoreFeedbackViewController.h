//
//  MHStoreFeedbackViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

@interface MHStoreFeedbackViewController : MHBaseViewController
/*
 type 0 拒绝退款   1 反馈意见
 */
@property (nonatomic,assign)NSInteger type;

//type = 0时要传值   退款ID
@property (nonatomic,assign)NSInteger refund_id;
//type = 1时要传值   商家ID
@property (nonatomic,assign)NSInteger merchant_id;

@end
