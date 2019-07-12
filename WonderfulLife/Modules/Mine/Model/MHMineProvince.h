//
//  MHProvince.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHMineCity.h"

@interface MHMineProvince : NSObject
@property (nonatomic, strong) NSNumber *province_id; // 省份id
@property (nonatomic, copy) NSString *province_name;  // 所属省份	广东省
@property (nonatomic,strong) NSArray <MHMineCity *>*cityList;
@end
