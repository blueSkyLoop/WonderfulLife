//
//  MHVolActiveModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolActiveModel : NSObject

/// 服务ID
@property (strong,nonatomic) NSNumber *activity_id;

/// 服务名称
@property (copy,nonatomic) NSString *activity_name;

/// 简介
@property (copy,nonatomic) NSString *activity_summary;

/** activity_type	Long	0	服务项目类型，0表示公益服务项目，1表示普通服务项目*/
@property (nonatomic, strong) NSNumber  *activity_type;

@end
