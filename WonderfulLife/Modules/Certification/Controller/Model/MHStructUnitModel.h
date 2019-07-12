//
//  MHStructUnitModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStructUnitModel : NSObject

/// 相关信息
@property (strong,nonatomic) NSNumber *struct_id;

/// 单元号
@property (copy,nonatomic) NSString *unit_no;

// 0表示无区域，1表示有区域
@property (nonatomic, assign) BOOL has_area;
@end
