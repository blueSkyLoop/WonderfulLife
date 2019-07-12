//
//  MHReportRepairTypeViewController.h
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

@interface MHReportRepairTypeViewController : MHBaseViewController
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,assign,getter=isRepeatEnter)BOOL repeatEnter;
@property(nonatomic,assign,getter=isListEnter)BOOL listEnter;

@property(nonatomic,strong) NSNumber *repairment_category_id;

@end
