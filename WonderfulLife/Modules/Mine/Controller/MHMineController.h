//
//  WHMineController.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHMineController : UIViewController
@property (nonatomic,copy) void (^refreshBlock)();
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) void (^refreshVoStateBlock)();
@property (nonatomic,copy) void (^refreshCetifiStateBlock)(NSInteger);
@end
