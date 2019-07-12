//
//  MHMineRoomModel.h
//  WonderfulLife
//
//  Created by 哈马屁 on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMineRoomModel : NSObject

@property (nonatomic,strong) NSNumber * audit_status;
@property (nonatomic,strong) NSNumber *lv_id;
@property (nonatomic,strong) NSNumber *struct_id;
@property (nonatomic,strong) NSNumber *community_id;
@property (nonatomic,strong) NSNumber *prop_owner_id;

@property (nonatomic,copy) NSString *audit_status_str;
@property (nonatomic,copy) NSString *community_name;
@property (nonatomic,copy) NSString *real_name;
@property (nonatomic,copy) NSString *room_info;

@end
