//
//  MHMineMerWithDrawParameter.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithDrawParameter.h"

@implementation MHMineMerWithDrawParameter
//我是商家-提现模块-主页
+ (NSDictionary *)merchantWithDrawMain{
    return @{};
}

//我是商家-提现模块-申请提现
+ (NSDictionary *)merchantApplyWithDraw{
    return @{};
}

//我是商家-提现模块-提现详情
+ (NSDictionary *)merchantWithdrawRecordDetailWithWithdraw_no:(NSString *)withdraw_no page:(NSInteger)page{
    return @{
             @"withdraw_no":withdraw_no,
             @"page":@(page)
             };
}

//我是商家-提现模块-提现记录
+ (NSDictionary *)merchantWithdrawReocrdListWithPage:(NSInteger)page{
    return @{@"page":@(page)};
}
@end
