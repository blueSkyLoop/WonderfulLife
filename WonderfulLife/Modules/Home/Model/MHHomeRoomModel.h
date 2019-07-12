//
//  MHHomeRoomModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeRoomModel : NSObject
@property (nonatomic,copy) NSString *property_id;
@property (nonatomic,copy) NSString *property_name;
@property (nonatomic,copy) NSString *owner_name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) float cellHeight;

@end
