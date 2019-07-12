//
//  MHMineQrInfoHeaderView.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineMerchantInfoModel ;
@interface MHMineQrInfoHeaderView : UIView

@property (nonatomic, strong) MHMineMerchantInfoModel  *model;

+ (instancetype)mineQRInfoHeaderView:(MHMineMerchantInfoModel *)model ;

@end
