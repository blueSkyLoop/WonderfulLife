//
//  MHVolunteerSupportModel.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHVolunteerSupportModel : NSObject

// url  : volunteer/support/list
@property (nonatomic, strong) NSNumber *support_id;
@property (nonatomic, copy) NSString *support_name;

@property (nonatomic, copy)   NSString * create_datetime;
@property (nonatomic, copy)   NSString * modify_datetime;
/** 是否被点选 */
@property (assign,nonatomic) NSInteger is_own;


@end
