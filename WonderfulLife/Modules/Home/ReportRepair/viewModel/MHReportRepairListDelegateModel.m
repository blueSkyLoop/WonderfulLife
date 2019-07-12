//
//  MHReportRepairListDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListDelegateModel.h"
#import "MHReportRepairListCell.h"
#import "ReactiveObjC.h"

@implementation MHReportRepairListDelegateModel


- (void)mh_delegateConfig{
    @weakify(self)
    self.mh_tableViewRowCellBlock = ^(NSIndexPath *indexPath, UITableViewCell<MHCellConfigDelegate> *acell){
        MHReportRepairListCell *cell = (MHReportRepairListCell *)acell;
        @strongify(self);
        cell.cellClikBlock = self.reportRepairCellClikBlock;
    };
}
@end
