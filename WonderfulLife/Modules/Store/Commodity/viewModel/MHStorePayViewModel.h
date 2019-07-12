//
//  MHStorePayViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHStorePayViewModel : MHBaseViewModel

@property (nonatomic,copy)NSString *payTypeStr;
@property (nonatomic,copy)NSString *payData;


@property (nonatomic,copy)NSString *password;

//支付订单
@property (nonatomic,strong,readonly)RACCommand *goodsBuyCommand;

//支付前校验接口
@property (nonatomic,strong,readonly)RACCommand *goodsBuyCheckCommand;

//密码检测
- (void)startPasswordCheck;


@end
