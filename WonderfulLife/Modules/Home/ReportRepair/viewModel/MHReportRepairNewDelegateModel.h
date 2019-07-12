//
//  MHReportRepairNewDelegateModel.h
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHBaseTableDelegateModel.h"

@interface MHReportRepairNewDelegateModel : MHBaseTableDelegateModel
@property (nonatomic,copy)void(^reportRepairCellClikBlock)(UIButton *btn,id model);

@end
