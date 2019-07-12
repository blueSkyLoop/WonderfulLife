//
//  MHMineMerchantHandler.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantHandler.h"
#import "MHMineMerchantInfoModel.h"
#import "MHMineMerFinModel.h"
#import "MHMineMerchantPayModel.h"

#import "MHNetworking.h"
#import "YYModel.h"
#import "NSObject+isNull.h"
@implementation MHMineMerchantHandler


+ (void)mineMerColQrCodeRequestWithParma:(NSDictionary *)parma Block:(void(^)(MHMineMerchantInfoModel *model , BOOL Success))callback Failure:(void (^)(NSString *errmsg))failure {
    [[MHNetworking shareNetworking] post:@"mall/merchant/qr_code_charge/get" params:parma success:^(id data) {
        MHMineMerchantInfoModel *model = [MHMineMerchantInfoModel yy_modelWithJSON:data];
        callback(model,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)mineScanCollectionOfMoneyWithParma:(NSMutableDictionary *)parma success:(void(^)(MHMineMerchantPayModel *resultModel ,BOOL isSuccess))isSuccess Failure:(void (^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"mall/merchant/scan" params:parma success:^(id data) {
        MHMineMerchantPayModel * result = [MHMineMerchantPayModel yy_modelWithJSON:data];
        isSuccess(result,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)mineMerFinanceRecordListWithParma:(NSDictionary *)parma callBack:(void (^)(MHMineMerFinModel *, BOOL))callBack Failure:(void (^)(NSString *))failure {
    [[MHNetworking shareNetworking] post:@"mall/merchant/finance/record/list" params:parma success:^(id data) {
        MHMineMerFinModel *model = [MHMineMerFinModel yy_modelWithJSON:data];
        callBack(model,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

@end
