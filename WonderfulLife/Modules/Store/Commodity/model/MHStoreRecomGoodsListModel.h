//
//  MHStoreRecomGoodsListModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreRecomGoodsListModel : NSObject
//商品名称
@property (nonatomic,copy)NSString *coupon_name;
//商品封面图片
@property (nonatomic,copy)NSString *img_cover;
//销量
@property (nonatomic,assign)NSInteger coupon_sales;
//商品价格
@property (nonatomic,copy)NSString *coupon_price;
//商品id
@property (nonatomic,assign)NSInteger coupon_id;
//门市价
@property (nonatomic,copy)NSString *retail_price;
//商家名称
@property (nonatomic,copy)NSString *merchant_name;
//距离
@property (nonatomic,copy)NSString *distance;

//这个方法主要是商家列表里的数据转换成这个模型（因为商家商品列表和推荐商品列表结构不一致，后台不愿统一）
- (id)initWithMerchantCouponDic:(NSDictionary *)dict;


@end
