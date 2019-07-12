//
//  MHStoreHomeModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/1.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MHStHoShopModel : NSObject

@property (nonatomic,strong) NSNumber *merchant_id;
@property (nonatomic,copy) NSString *merchant_name;
@property (nonatomic,copy) NSString *img_cover;
@property (nonatomic,assign) NSInteger star;

@end


@interface MHStHomeGoodsModel : NSObject
@property (nonatomic,strong) NSNumber *coupon_id;
@property (nonatomic,copy) NSString *coupon_name;
@property (nonatomic,copy) NSString *img_cover;
@property (nonatomic,copy) NSString *coupon_sales;
@property (nonatomic,copy) NSString *coupon_price;
@property (nonatomic,copy) NSString *retail_price;
@property (nonatomic,copy) NSString *merchant_name;
@property (nonatomic,copy) NSString *distance;
@end


@interface MHStHoBannerAdModel : NSObject
@property (nonatomic,strong) NSNumber *ad_id;
@property (nonatomic,copy) NSString *img_cover;
/** 0表示内链，1表示外链，2表示无链接 */
@property (nonatomic,strong) NSNumber *link_type;
/** 0代表商家，1代表商品 */
@property (nonatomic,strong) NSNumber *link_target;
/** 链接目标id */
@property (nonatomic,strong) NSNumber *target_id;
/** 目标URL */
@property (nonatomic,copy) NSString *link;

@end

@interface MHStHoBusinessModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon_url;
@property (nonatomic,assign) BOOL is_enable;
@property (nonatomic,copy) NSString *alert_msg;

@end

@class MHStoreRecomGoodsListModel;
@interface MHStHoAllGoodsModel : NSObject

@property (nonatomic,assign) BOOL has_next;
@property (nonatomic,strong) NSMutableArray <MHStoreRecomGoodsListModel *>*list;

@end

@interface MHStoreHomeModel : NSObject

@property (nonatomic,strong) NSArray <MHStHoShopModel *>*recommend_merchant_list;
@property (nonatomic,strong) NSArray <MHStHoBannerAdModel *>*banner_list;
@property (nonatomic,strong) NSArray <MHStHomeGoodsModel *>*recommend_coupon_list;
@property (nonatomic,strong) NSArray <MHStHoBusinessModel *>*business_buttons;
@property (nonatomic,strong) MHStHoAllGoodsModel *coupon_list;

@end
