//
//  MHStoShopSummaryModel.h
//  WonderfulLife_dev
//
//  Created by 梁斌文 on 2017/11/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoShopSummaryModel : NSObject
@property (nonatomic,strong) NSNumber *merchant_id;
@property (nonatomic,copy) NSString *merchant_name;
@property (nonatomic,strong) NSString *img_cover;
@property (nonatomic,assign) NSInteger star;
@property (nonatomic,copy) NSString *merchant_summary;
@property (nonatomic,assign) double average_spend;
@property (nonatomic,copy) NSString *distance;

@end

