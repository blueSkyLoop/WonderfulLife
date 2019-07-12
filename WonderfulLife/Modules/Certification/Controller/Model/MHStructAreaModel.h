//
//  MHStructAreaModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStructAreaModel : NSObject

// 楼栋信息id
@property (strong,nonatomic) NSNumber *struct_id;

// 管理区名字（若无区域显示“无区域”）
@property (copy,nonatomic) NSString *area;

// 0表示无区域，1表示有区域
@property (nonatomic, assign) BOOL has_area;

@end
