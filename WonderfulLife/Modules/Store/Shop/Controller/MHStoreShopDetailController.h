//
//  MHStoreShopDetailController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/26.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHStoShopDetailModel;

@interface MHStoreShopDetailController : UIViewController
@property (nonatomic,strong) NSNumber *merchant_id;
- (instancetype)initWithmerchant_id:(NSNumber *)merchant_id;
@property (nonatomic,strong) MHStoShopDetailModel *model;
@end
