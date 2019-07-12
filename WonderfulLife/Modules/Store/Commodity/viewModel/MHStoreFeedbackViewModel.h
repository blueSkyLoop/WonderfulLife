//
//  MHStoreFeedbackViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHStoreFeedbackViewModel : MHBaseViewModel

@property (nonatomic,assign)NSInteger refund_id;

@property (nonatomic,assign)NSInteger merchant_id;

@property (nonatomic,copy)NSString *reason;

//拒绝退款
@property (nonatomic,strong,readonly)RACCommand *refundCommand;

//反馈意见
@property (nonatomic,strong,readonly)RACCommand *feedbackCommand;

@end
