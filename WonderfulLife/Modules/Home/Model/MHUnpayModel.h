//
//  MHUnpayModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHUnpaySubjectModel.h"

@interface MHUnpayModel : NSObject
@property (nonatomic,strong) NSArray <MHUnpaySubjectModel *> *list;
@property (nonatomic,copy) NSString *sum;
@property (nonatomic,strong) NSNumber *property_id;

@end
