//
//  MHMinMerWithdrawMainModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMinMerWithdrawMainModel : NSObject
//可提现积分
@property (nonatomic,copy)NSString *amount_withdraw;
//账户余额
@property (nonatomic,copy)NSString *amount_balance;
//提现模式
@property (nonatomic,copy)NSString *withdraw_mode;
//银行名称
@property (nonatomic,copy)NSString *bank_name;
//银行账号
@property (nonatomic,copy)NSString *bank_card;
//持卡人真实姓名
@property (nonatomic,copy)NSString *account_name;
//提现按钮名称，如“每月1号自动提现”、“暂时无法发起提现”
@property (nonatomic,copy)NSString *withdraw_btn_name;
//提示信息
@property (nonatomic,copy)NSString *alert_msg;
//提现模式枚举值，0表示手动提现，1表示每月自动提现，2每周自动提现
@property (nonatomic,assign)NSInteger withdraw_mode_value;
//手动提现模式下能否提现，0表示不能提现，1表示可以提现
@property (nonatomic,assign)NSInteger is_manual_withdrawable;

@end
