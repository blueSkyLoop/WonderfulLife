//
//  MHMerchantOrderViewModel.h
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

typedef NS_ENUM(NSUInteger, MHMerchantOrderType) {
    MHMerchantOrderTypeNormal,
    MHMerchantOrderTypeRefundDoing,
    MHMerchantOrderTypeManager,
};

@interface MHMerchantOrderViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) RACCommand *pullListCommand;     //买家 - 拉取列表数据
@property (nonatomic,strong) RACCommand *deleteOrderCommand;     //买家 - 拉取列表数据
@property (nonatomic,assign) MHMerchantOrderType type;

- (void)registerCommand;
@end
