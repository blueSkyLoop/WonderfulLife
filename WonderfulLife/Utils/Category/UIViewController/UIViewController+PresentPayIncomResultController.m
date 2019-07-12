//
//  UIViewController+PresentPayIncomResultController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+PresentPayIncomResultController.h"
#import "MHMineMerColResultController.h"
#import "MHNavigationControllerManager.h"
@implementation UIViewController (PresentPayIncomResultController)

- (void)mh_presentResultControllerWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type {
    
    MHMineMerColResultController *vc = [[MHMineMerColResultController alloc] initWithModel:model type:type openType:MerResultOpenType_Present];
    vc.hidesBottomBarWhenPushed = YES;
    MHNavigationControllerManager *navi = [[MHNavigationControllerManager alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)mh_pushResultControllerWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type {
    MHMineMerColResultController *vc = [[MHMineMerColResultController alloc] initWithModel:model type:type openType:MerResultOpenType_Push];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
