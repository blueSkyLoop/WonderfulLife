//
//  MHReportRepairTypeModel.h
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHReportRepairTypeModel : NSObject
/**
 -1，大类没有父类id
 */
@property (nonatomic,strong)NSNumber *parent_id;
/**
 分类ID
 */
@property (nonatomic,strong)NSNumber *repairment_category_id;
/**
 分类名字
 */
@property (nonatomic,  copy)NSString *repairment_category_name;
/**
 是否有下一级
 */
@property (nonatomic,strong)NSNumber *has_next;
/**
 0|1,1是户内
 */
@property (nonatomic,strong)NSNumber *is_indoor;
/**
 大于1的值（目前只有2）
 */
@property (nonatomic,strong)NSNumber *depth;

@end
