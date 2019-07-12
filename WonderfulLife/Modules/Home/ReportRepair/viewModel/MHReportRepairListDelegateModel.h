//
//  MHReportRepairListDelegateModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseTableDelegateModel.h"

@interface MHReportRepairListDelegateModel : MHBaseTableDelegateModel
//index  1 取消   2 去评价  3 仍未解决
@property (nonatomic,copy)void(^reportRepairCellClikBlock)(UIButton *btn,NSInteger index,id model);

@end
