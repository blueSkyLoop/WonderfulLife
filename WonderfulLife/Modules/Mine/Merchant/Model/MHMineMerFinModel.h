//
//  MHMineMerFinModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//   财务报表 model

#import <Foundation/Foundation.h>

@class MHMineMerFin_record , MHMineMerFin_record_list;

@interface MHMineMerFinModel : NSObject

/** 营业额*/
@property (nonatomic, copy)   NSString * turnover;

/** 积分收入*/
@property (nonatomic, copy)   NSString * income;

/** 累计提现*/
@property (nonatomic, copy)   NSString * withdraw_sum;

/** 财务报表*/
@property (nonatomic, strong) MHMineMerFin_record_list *finance_record_list;

@end


@interface MHMineMerFin_record_list : NSObject

@property (nonatomic, strong) NSNumber  *first;

@property (nonatomic, assign) BOOL  has_next;

@property (nonatomic, strong) NSNumber  *hasPrev;

@property (nonatomic, strong) NSNumber  *last;

@property (nonatomic, strong) NSArray <MHMineMerFin_record *>  *list;

@end



@interface MHMineMerFin_record : NSObject

/** 收入变化数额*/
@property (nonatomic, copy)   NSString * change_amount;

/** 收入变化类型 收入变化类型，0收入，1提现，2退款*/
@property (nonatomic, strong)   NSNumber * change_type;

/** 收入变化时间*/
@property (nonatomic, copy)   NSString * change_time;

/** 财务记录id */
@property (nonatomic, strong) NSNumber  *record_id;
@end

