//
//  MHStoreGoodsOrderDetailModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/1.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreGoodsOrderDetailModel : NSObject

//商品名称
@property (nonatomic,copy)NSString *coupon_name;
//商品价格
@property (nonatomic,copy)NSString *coupon_price;
//门市价
@property (nonatomic,copy)NSString *retail_price;
//商品销量
@property (nonatomic,copy)NSString *coupon_sales;
//商家名称
@property (nonatomic,copy)NSString *merchant_name;
//距离
@property (nonatomic,copy)NSString *distance;
//库存数量
@property (nonatomic,copy)NSString *inventory;



//自添加 （非后台返回）
//当前选中多少数量
@property (nonatomic,assign)NSInteger currentNum;
//总价格，已四舍五入保留两位小数点，转换成了字符串
@property (nonatomic,copy)NSString *totalPriceStr;

@end
