//
//  MHHoPayExpensesModel.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHoPayExpensesModel : NSObject
/*
 pay_project	String	电费	缴费项目
 pay_amount	String	120.00	已缴费明细项金额（x.xx）
 */

/**
 缴费项目
 */
@property (copy, nonatomic) NSString *pay_project;
/**
 已缴费明细项金额
 */
@property (copy, nonatomic) NSString *pay_amount;

@end
