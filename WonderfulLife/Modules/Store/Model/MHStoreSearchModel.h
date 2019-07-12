//
//  MHStoreSearchModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHOOSImageModel;
@interface MHStoreSearchGoodsModel : NSObject
@property (nonatomic,copy)NSString *coupon_name;
//商品封面图片
@property (nonatomic,copy)NSArray <MHOOSImageModel *>*img_cover;
//销量
@property (nonatomic,assign)NSInteger coupon_sales;
//商品价格
@property (nonatomic,copy)NSString *coupon_price;
//商品id
@property (nonatomic,strong)NSNumber * coupon_id;
//门市价
@property (nonatomic,copy)NSString *retail_price;
//商家名称
@property (nonatomic,copy)NSString *merchant_name;
@property (nonatomic,copy)NSString *distance;

@end


@class MHStoShopDetailModel;
@interface MHStoreSearchModel : NSObject
@property (nonatomic,strong) NSArray <MHStoShopDetailModel *>*merchant_list_vos;
@property (nonatomic,strong) NSArray <MHStoreSearchGoodsModel *>*coupon_list_vos;
@property (nonatomic,assign) BOOL has_next_merchant;
@property (nonatomic,assign) BOOL has_next_coupon;

@end
