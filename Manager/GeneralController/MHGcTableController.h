//
//  MHGcTableController.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHGcTableModel;
@interface MHGcTableController : UIViewController
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSArray <MHGcTableModel*>*dataSource;
@property (nonatomic, copy) void(^didSelectBlock)(MHGcTableModel * model);

@end

@interface MHGcTableModel : NSObject
@property (nonatomic, strong) NSNumber *team_id;
@property (nonatomic, copy) NSString *team_name;
@property (nonatomic,strong) NSNumber *role_in_team;

@property (nonatomic,strong) NSNumber *category_id;
@property (nonatomic,copy) NSString *category_name;

@end
