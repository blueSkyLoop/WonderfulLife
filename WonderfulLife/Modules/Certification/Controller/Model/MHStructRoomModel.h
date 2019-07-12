//
//  MHStructRoomModel.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStructRoomModel : NSObject
/// <#summary#>
@property (strong,nonatomic) NSNumber *struct_id;

@property (nonatomic,strong) NSNumber *property_id;
/// <#summary#>
@property (copy,nonatomic) NSString *room_no;
/// <#summary#>
@property (copy,nonatomic) NSString *phone_number;
/// <#summary#>
@property (copy,nonatomic) NSString *first_name;

@property (nonatomic,copy) NSString *owner_name;

/// <#summary#>
@property (copy,nonatomic) NSString *name_length;

/** 0:没有身份证信息，1：有身份证信息 */
@property (assign,nonatomic) BOOL has_id_card;

/** 整个楼栋拼接信息*/
@property (nonatomic, copy)   NSString * room_info;

@end
