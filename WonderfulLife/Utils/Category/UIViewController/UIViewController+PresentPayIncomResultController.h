//
//  UIViewController+PresentPayIncomResultController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMerPayIncomEnumResult.h"
@class MHMineMerchantPayModel ;
@interface UIViewController (PresentPayIncomResultController)

- (void)mh_presentResultControllerWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type ;

- (void)mh_pushResultControllerWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type ;

@end
