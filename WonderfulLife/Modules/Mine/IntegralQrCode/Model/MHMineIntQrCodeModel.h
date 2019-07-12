//
//  MHMineIntQrCodeModel.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMineIntQrCodeModel : NSObject

@property (nonatomic, copy)   NSString * qr_code;

@property (nonatomic, copy)   NSString * bar_code;

@property (nonatomic, copy)   NSString * name;

@property (nonatomic, copy)   NSString * score;
@end


/** 
 qr_code true string Base64 二维码
 bar_code true string   Base64 条形码
 name   true string 账号名称
 score  true string  爱心积分
 
 */
