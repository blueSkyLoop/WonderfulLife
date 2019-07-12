//
//  MHStoreGoodsDetailModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHStoreGoodsImageModel.h"

@interface MHStoreGoodsDetailModel : NSObject
//顶部显示的名称,目前是"商品详情页
@property (nonatomic,copy)NSString *top_title;
//封面图片,商品详情页的顶部图片
@property (nonatomic,strong)MHStoreGoodsImageModel *img_cover;
//商品名称
@property (nonatomic,copy)NSString *coupon_name;
//商品价格
@property (nonatomic,copy)NSString *coupon_price;
//门市价
@property (nonatomic,copy)NSString *retail_price;
//星级
@property (nonatomic,assign)NSInteger star;
//经度
@property (nonatomic,assign)double gps_lng;
//纬度
@property (nonatomic,assign)double gps_lat;
//所属商家名称
@property (nonatomic,copy)NSString *merchant_name;
//有效期开始时间
@property (nonatomic,copy)NSString *expiry_time_begin;
//商品详情
@property (nonatomic,copy)NSString *remark;
//商品图片集合
@property (nonatomic,copy)NSArray <MHStoreGoodsImageModel *>*img_list;
//商家id
@property (nonatomic,assign)NSInteger merchant_id;
//有效期结束时间
@property (nonatomic,copy)NSString *expiry_time_end;
//商品id
@property (nonatomic,assign)NSInteger coupon_id;
//库存数量
@property (nonatomic,assign)NSInteger inventory;
//销量
@property (nonatomic,assign)NSInteger sales;
//上下架状态,0上架,1下架
@property (nonatomic,assign)NSInteger sale_status;
//距离
@property (nonatomic,copy)NSString *distance;
//状态,0为正常,1为该小区已关闭商城功能
@property (nonatomic,assign)NSInteger status;

//自己添加，非后台返回
//当前选中多少数量
@property (nonatomic,assign)NSInteger currentNum;
//总价格，已四舍五入保留两位小数点，转换成了字符串
@property (nonatomic,copy)NSString *totalPriceStr;

@end
