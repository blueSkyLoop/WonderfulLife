//
//  MHHoPayDetailsModel.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHHoPayExpensesModel.h"

@interface MHHoPayDetailsModel : NSObject
/*
 pay_project	String	电费	缴费项目
 pay_amount	String	120.00	已缴费明细项金额（x.xx）
 pay_datetime	String	2017-7-22 14:08:42	缴费时间
 pay_way	String	微信支付	支付方式
 */

/**
 缴费项目数组
 */
@property (nonatomic, strong) NSArray *list;
/**
 缴费时间
 */
@property (copy, nonatomic) NSString *pay_datetime;
/**
 支付方式
 */
@property (copy, nonatomic) NSString *pay_way;
/**
 缴费金额
 */
@property (copy,nonatomic) NSString *total_money;
/**
 实际支付
 */
@property (copy,nonatomic) NSString *actual_pay_money;
/**
 积分抵扣,默认为0.00
 */
@property (copy,nonatomic) NSString *pay_score;

@end
