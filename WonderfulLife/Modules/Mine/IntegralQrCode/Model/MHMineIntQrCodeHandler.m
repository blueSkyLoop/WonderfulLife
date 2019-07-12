//
//  MHMineIntQrCodeHandler.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineIntQrCodeHandler.h"
#import "MHMineMerchantInfoModel.h"
#import "MHNetworking.h"
#import "YYModel.h"


@implementation MHMineIntQrCodeHandler


+ (void)mineIntQrCodeRequestCallBack:(void (^)(BOOL Success, MHMineMerchantInfoModel *model))callback Failure:(void (^)(NSString *errmsg))failure {

    [[MHNetworking shareNetworking] post:@"qr-code/score/get" params:nil success:^(id data) {
        MHMineMerchantInfoModel *model = [MHMineMerchantInfoModel yy_modelWithJSON:data];
        callback(YES,model);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

@end
