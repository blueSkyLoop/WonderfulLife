//
//  MHMerchantOrderViewModel.m
//  WonderfulLife
//
//  Created by zz on 30/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderViewModel.h"
#import "MHMerChantOrderRequestHandler.h"

@implementation MHMerchantOrderViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)registerCommand {
    

}

#pragma mark - Getter
- (RACCommand *)pullListCommand {
    if (!_pullListCommand) {
        @weakify(self)
        _pullListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            switch (self.type) {
                case MHMerchantOrderTypeNormal:
                    return [MHMerChantOrderRequestHandler pullNormalListSignal:input];
                    break;
                case MHMerchantOrderTypeManager:
                    return [MHMerChantOrderRequestHandler pullManagerListSignal:input];
                    break;
                case MHMerchantOrderTypeRefundDoing:
                    return [MHMerChantOrderRequestHandler pullRefundDoingListSignal:input];
                    break;
            }
            return [RACSignal empty];
        }];
    }
    return _pullListCommand;
}

- (RACCommand *)deleteOrderCommand {
    if (!_deleteOrderCommand) {
        @weakify(self)
        _deleteOrderCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSArray *input) {
            @strongify(self)
            if (self.type == MHMerchantOrderTypeManager) {
                return [MHMerChantOrderRequestHandler deleteSomeOneMerchantOrder:input];
            }else if (self.type == MHMerchantOrderTypeRefundDoing) {
                return [MHMerChantOrderRequestHandler deleteSomeMerchantRefundOrder:input];
            }
            return [MHMerChantOrderRequestHandler deleteSomeOneOrder:input];
        }];
    }
    return _deleteOrderCommand;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
