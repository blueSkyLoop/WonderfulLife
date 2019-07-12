//
//  MHMerChantOrderRequestHandler.h
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface MHMerChantOrderRequestHandler : NSObject


+ (RACSignal *)pullNormalListSignal:(id)input;
+ (RACSignal *)pullManagerListSignal:(id)input;
+ (RACSignal *)pullRefundDoingListSignal:(id)input;
+ (RACSignal *)pullOrderDetailSignal:(id)input;
+ (RACSignal *)deleteSomeOneOrder:(id)input;
+ (RACSignal *)reviewMerchantOrGoodsOrder:(id)input;
+ (RACSignal *)pullMerchantOrderDetailSignal:(id)input;
+ (RACSignal *)comfirmRefundOrder:(id)input;
+ (RACSignal *)deleteSomeOneMerchantOrder:(id)input;
+ (RACSignal *)postGoodsOrderComment:(id)input;
+ (RACSignal *)deleteSomeMerchantRefundOrder:(id)input;
@end
