//
//  MHVoSerUnJoinTeamCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolSerTeamModel;

@interface MHVoSerUnJoinTeamCell : UITableViewCell
/// <#summary#>
@property (strong,nonatomic) MHVolSerTeamModel *model;

@property (nonatomic, strong) NSIndexPath  *indexPath;
@end
