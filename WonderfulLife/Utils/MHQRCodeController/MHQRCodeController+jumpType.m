//
//  MHQRCodeController+jumpType.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHQRCodeController+jumpType.h"
#import "UINavigationController+MHDirectPop.h"
#import "UIViewController+PresentPayIncomResultController.h"

#import "LIntegralsPayViewController.h"
#import "MHStoreConfirmPayViewController.h"
#import "MHMineInputFieldController.h"
#import "MHMineMerColResultController.h"
#import "MHMineMerchantHandler.h"
#import "MHMerchantOrderDetailController.h"


@implementation MHQRCodeController (jumpType)

- (void)jumpToPageWithQrcodeType:(MHQrcodeScanType)type infor:(NSDictionary *)inforDic{
    switch (type) {
        case MHQrcode_scanTypeVem://自助售卖机
        {
            LIntegralsPayViewController *interalsVC = [LIntegralsPayViewController new];
            interalsVC.goodsInfor = [self coalescingParameterWithInfor:inforDic];
            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
            [self.navigationController pushViewController:interalsVC animated:YES];
            
        }
            break;
        case MHQrcode_scanTypeSeller://商家收款码,每个商户生成时，都生成一个专属商户二维码，用于商户出示给买家扫描进行定向付款；用户来扫
        {
            MHStoreConfirmPayViewController *merchantVC = [MHStoreConfirmPayViewController new];
            merchantVC.infor = [self coalescingParameterWithInfor:inforDic];
            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
            [self.navigationController pushViewController:merchantVC animated:YES];
            
        }
            break;
        case MHQrcode_scanTypeScore://积分二维码(有条码)用于向商家支付使用，商家来扫
        {
            [self qrcodePayWithInfor:[self coalescingParameterWithInfor:inforDic]];
        }
            break;
        case MHQrcode_scanTypeCouponOrder://订单二维码(消费订单)
        {
            [self closeOrderCostView];
            self.orderDetailView = [MHStoreOrdersConsumptionView loadViewFromXib];
            [self.orderDetailView configWithDict:inforDic];
            self.orderDetailView.tag = 9999999;
            [self.view.window addSubview:self.orderDetailView];
            [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            self.orderDetailView.buttonClikBlock = ^(NSInteger index){
                @strongify(self);
                [self handleOrderWithIndex:index];
            };
        }
            break;
            
        default:
            break;
    }
    
}
//合并参数
- (NSMutableDictionary *)coalescingParameterWithInfor:(NSDictionary *)inforDic{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if(self.parma && self.parma.count){
        [muDic addEntriesFromDictionary:self.parma];
    }
    if(inforDic && inforDic.count){
        [muDic addEntriesFromDictionary:inforDic];
    }
    return muDic;
}

//扫出来之后在这里支付
- (void)qrcodePayWithInfor:(NSMutableDictionary *)parameter{
    
    [MHHUDManager show];
    [MHMineMerchantHandler mineScanCollectionOfMoneyWithParma:parameter success:^(MHMineMerchantPayModel *resultModel, BOOL isSuccess) {
        [MHHUDManager dismiss];
        [self mh_pushResultControllerWithModel:resultModel type:MerColResultType_CompIncome];
    } Failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [self mh_pushResultControllerWithModel:nil type:MerColResultType_FailureIncome];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self startScan];
//        });
//        [MHHUDManager showText:errmsg Complete:^{
//            [self startScan];
//        }];
    }];
    
}

#pragma mark 订单消费
- (void)handleOrderWithIndex:(NSInteger)index{
    
    switch (index) {
        case 1://查看详情
        {
            MHMerchantOrderDetailController *vc = [MHMerchantOrderDetailController new];
            vc.controlType = MHMerchantOrderDetailControlTypeMerchant;
            vc.order_no = self.orderDetailView.inforDict[@"order_no"];
            self.orderDetailView.hidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2://取消
        {
            [self closeOrderCostView];
            [self startScan];
        }
            break;
        case 3://确定
        {
            NSString *order_no = self.orderDetailView.inforDict[@"order_no"];
            NSInteger type = [self.orderDetailView.inforDict[@"order_status_type"] integerValue];
            if (type == 1 || type == 6) {
                self.viewModel.order_no = order_no;
                if(!order_no) return;
                [self.viewModel.orderCostCommand execute:nil];
            }else{
                [self closeOrderCostView];
                [self startScan];
            }
            
        }
            break;
            
        default:
            break;
    }
}


-(void)closeOrderCostView{
    if(self.orderDetailView && self.orderDetailView.superview){
        [self.orderDetailView removeFromSuperview];
    }
    self.orderDetailView = nil;
}



@end
