//
//  MHStoreGoodsImageModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreGoodsImageModel : NSObject
//原图图片地址
@property (nonatomic,copy)NSString *url;
//图片宽度
@property (nonatomic,copy)NSString *width;
//图片高度
@property (nonatomic,copy)NSString *height;
//小图图片地址
@property (nonatomic,copy)NSString *s_url;

@end
