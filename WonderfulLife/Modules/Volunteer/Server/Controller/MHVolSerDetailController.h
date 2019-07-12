//
//  MHVolSerDetailController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  服务队详情 | 服务项目详情

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHVolSerDetailTypeJoinItem, // 参与服务项目
    MHVolSerDetailTypeTeam,//服务队
    MHVolSerDetailTypeItem,//服务项目
} MHVolSerDetailType;

@interface MHVolSerDetailController : UITableViewController

/// <#summary#>
@property (assign,nonatomic) MHVolSerDetailType type;

/// <#summary#>
@property (strong,nonatomic) NSNumber *detailId;

@end
