//
//  MHMineMerWithdrawRecordModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMineMerWithdrawRecordModel : NSObject
//申请金额
@property (nonatomic,copy)NSString *amount_apply;
//提现状态
@property (nonatomic,copy)NSString *withdraw_status;
//申请时间
@property (nonatomic,copy)NSString *apply_time;
//提现单号
@property (nonatomic,copy)NSString *withdraw_no;
//流水时段
@property (nonatomic,copy)NSString *period;
//提现状态枚举值，0表示申请中，1表示提现成功
@property (nonatomic,assign)NSInteger withdraw_status_value;


@end
