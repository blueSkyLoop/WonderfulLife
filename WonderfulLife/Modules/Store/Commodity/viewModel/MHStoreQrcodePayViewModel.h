//
//  MHStoreQrcodePayViewModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/1.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewModel.h"

@interface MHStoreQrcodePayViewModel : MHBaseViewModel

//总积分(输入的)
@property (nonatomic,copy)NSString *totalScore;
//商家id
@property (nonatomic,copy)NSString *merchant_id;

//确定支付
@property (nonatomic,strong,readonly)RACCommand *payCommand;

@end
