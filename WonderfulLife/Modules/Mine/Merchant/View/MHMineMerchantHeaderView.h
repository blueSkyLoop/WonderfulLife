//
//  MHMineMerchantHeaderView.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineMerchantInfoModel ,MHMineMerchantHeaderView;
typedef void(^infoBlock)(MHMineMerchantHeaderView *viwe);
@interface MHMineMerchantHeaderView : UIView

@property (nonatomic, strong) MHMineMerchantInfoModel  *model;

+ (MHMineMerchantHeaderView *)merCreatHeaderViewWithFrame:(CGRect)frame  block:(infoBlock)block;

- (void)reloadDataWitModel:(MHMineMerchantInfoModel *)model ;
@end
