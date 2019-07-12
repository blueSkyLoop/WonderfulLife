//
//  MHVolServiceTimeController.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//   服务时长 & 查看考勤

#import <UIKit/UIKit.h>
#import "MHVolCheckTimeEnum.h"
@interface MHVoSerCheckTimeController : UIViewController

/**服务队id或者服务项目id*/
@property (nonatomic, strong) NSNumber  *idNum;

/** id所属类型，a 表示服务项目，t 表示服务队 */
@property (nonatomic, copy)   NSString * id_type;

- (instancetype)initWithType:(MHVolCheckTimeType)type ;

@end
