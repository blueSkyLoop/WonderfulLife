//
//  MHMerchantOrderController.h
//  WonderfulLife
//
//  Created by zz on 23/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHMerchantOrderListType) {
    MHMerchantOrderListTypeALL,
    MHMerchantOrderListTypeUnUsed, //待使用
    MHMerchantOrderListTypeUnPaid,
};

@interface MHMerchantOrderController : UIViewController
@property (nonatomic,assign)MHMerchantOrderListType type;
@end
