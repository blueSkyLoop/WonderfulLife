//
//  MHQRCodeController+jumpType.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHQRCodeController.h"
#import "MHQRCodeViewModel.h"
#import "MHStoreOrdersConsumptionViewModel.h"

@interface MHQRCodeController (jumpType)

- (void)jumpToPageWithQrcodeType:(MHQrcodeScanType)type infor:(NSDictionary *)inforDic;

-(void)closeOrderCostView;

@end
