//
//  MHHomeHTMLModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeHTMLModel : NSObject

@property (nonatomic, assign) NSInteger scope_exchange_enable;

@property (nonatomic, assign) NSInteger paying_money_enable;

@property (nonatomic, assign) NSInteger free_interest_shopping_enable;

@property (nonatomic, copy)   NSString * paying_money_url;

@property (nonatomic, copy)   NSString * free_interest_shopping_url;

/**
 *
 scope_exchange_enable	int	1	积分兑换控制是否可用,1：显示；0：不显示
 paying_money_enable	int	1	汇理财控制是否可用,1：显示；0：不显示
 free_interest_shopping_enable	int	1	免息商城控制是否可用,1：显示；0：不显示
 paying_money_url	string	http://	汇理财url
 free_interest_shopping_url	string	http://xxx	免息商城url
 */

@end
