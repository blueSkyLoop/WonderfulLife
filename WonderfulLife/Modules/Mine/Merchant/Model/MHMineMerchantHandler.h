//
//  MHMineMerchantHandler.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHMineMerchantInfoModel,MHMineMerFinModel ,MHMineMerchantPayModel;
@interface MHMineMerchantHandler : NSObject
/**
 *  我是商家：收款码
 *
 *  @parma   merchant_id
 *
 */
+ (void)mineMerColQrCodeRequestWithParma:(NSDictionary *)parma Block:(void(^)(MHMineMerchantInfoModel *model , BOOL Success))callback Failure:(void (^)(NSString *errmsg))failure ;



/**
 *  我是商家：扫码收款
 *
 *  @parma   merchant_id、amount（收款金额）
 *
 */
+ (void)mineScanCollectionOfMoneyWithParma:(NSMutableDictionary *)parma success:(void(^)(MHMineMerchantPayModel *resultModel ,BOOL isSuccess))isSuccess Failure:(void (^)(NSString *errmsg))failure;



/**
 *  我是商家： 财务报表
 *
 *  @parma   merchant_id    long
 *            date_begin    string
 *            date_end      string
 *            page          integer
 */
+ (void)mineMerFinanceRecordListWithParma:(NSDictionary *)parma callBack:(void(^)(MHMineMerFinModel * model,BOOL isSuccess))callBack Failure:(void (^)(NSString *errmsg))failure;
@end
