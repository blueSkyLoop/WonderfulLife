//
//  MHStoreRefundReasonModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreRefundReasonModel : NSObject
//原因
@property (nonatomic,copy)NSString *reason;
//理由id
@property (nonatomic,assign)NSInteger reason_id;

//是否选择 ，自已添加，非后台返回
@property (nonatomic,assign,getter=isSelected)BOOL selected;

@end
