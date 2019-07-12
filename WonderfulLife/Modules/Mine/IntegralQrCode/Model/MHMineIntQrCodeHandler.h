//
//  MHMineIntQrCodeHandler.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHMineMerchantInfoModel;

@interface MHMineIntQrCodeHandler : NSObject

+ (void)mineIntQrCodeRequestCallBack:(void (^)(BOOL Success, MHMineMerchantInfoModel *model))callback Failure:(void (^)(NSString *errmsg))failure ;


@end
