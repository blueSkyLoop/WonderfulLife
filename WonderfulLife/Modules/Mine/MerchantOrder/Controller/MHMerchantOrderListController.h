//
//  MHMerchantOrderListController.h
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMerchantOrderViewModel.h"

@protocol MHMerchantOrderListProtocal <NSObject>
- (void)MHMerchantOrderListPanGestureEvent:(UIPanGestureRecognizer*)gesture;
@end

@interface MHMerchantOrderListController : UIViewController
@property (nonatomic,assign) NSInteger viewControllerId;//区分订单状态
@property (nonatomic,assign) MHMerchantOrderType type;
@property (nonatomic,strong) NSNumber *merchant_id;
@property (nonatomic,  weak) id<MHMerchantOrderListProtocal>panDelegate;

- (void)refreshWithTag:(NSInteger)tag;
@end
