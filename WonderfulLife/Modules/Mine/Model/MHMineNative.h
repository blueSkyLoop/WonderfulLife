//
//  MHMineNative.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMineNative : NSObject
@property (nonatomic, strong) NSNumber *native_province_id;
/**
 * 籍贯所属省份
 */
@property (nonatomic, strong) NSString *native_province_name;

@property (nonatomic, strong) NSNumber *native_city_id;
/**
 *  籍贯所属城市
 */
@property (nonatomic, strong) NSString *native_city_name;
@end
