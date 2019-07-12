//
//  MHMineMerWithDrawParameter.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

//我是商家-提现模块-主页
static NSString *const API_mall_merchant_withdraw_main = @"mall/merchant/withdraw/main";

//我是商家-提现模块-申请提现
static NSString *const API_mall_merchant_withdraw_apply = @"mall/merchant/withdraw/apply";

//我是商家-提现模块-提现详情
static NSString *const API_mall_merchant_withdraw_record_get = @"mall/merchant/withdraw/record/get";

//我是商家-提现模块-提现记录
static NSString *const API_mall_merchant_withdraw_record_list = @"mall/merchant/withdraw/record/list";

@interface MHMineMerWithDrawParameter : NSObject
//我是商家-提现模块-主页
+ (NSDictionary *)merchantWithDrawMain;

//我是商家-提现模块-申请提现
+ (NSDictionary *)merchantApplyWithDraw;

//我是商家-提现模块-提现详情
+ (NSDictionary *)merchantWithdrawRecordDetailWithWithdraw_no:(NSString *)withdraw_no page:(NSInteger)page;

//我是商家-提现模块-提现记录
+ (NSDictionary *)merchantWithdrawReocrdListWithPage:(NSInteger)page;

@end
