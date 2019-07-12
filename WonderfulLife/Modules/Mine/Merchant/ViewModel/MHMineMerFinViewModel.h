//
//  MHMineMerFinViewModel.h
//  WonderfulLife
//
//  Created by Lucas on 17/11/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface MHMineMerFinViewModel : NSObject

@property (nonatomic, strong) NSMutableArray  *dataSource;

/**  获取列表数据 */
@property (strong,nonatomic,readonly) RACCommand *serCom;

/** 刷新列表 */
@property (strong,nonatomic,readonly) RACSubject *refreshSub;



@property (nonatomic, assign) NSInteger page;

@property (weak,nonatomic) UITableView *weakTableView;

@end
