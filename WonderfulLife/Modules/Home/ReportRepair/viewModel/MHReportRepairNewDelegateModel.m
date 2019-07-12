//
//  MHReportRepairNewDelegateModel.m
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewDelegateModel.h"
#import "MHReportRepairNewCommonCell.h"
#import "MHReportRepairNewEnableEditCell.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"

@implementation MHReportRepairNewDelegateModel

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 29.f;
    }
    return 0.01f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    return 56;
}


- (void)mh_delegateConfig{

    self.weakTableView.backgroundColor = MColorBackgroud;
    @weakify(self)

    self.mh_tableViewRowsNumBlock = ^NSInteger(NSInteger section) {
        @strongify(self);
        return [(NSArray*)self.dataArr[section] count];
    };

    self.mh_tableViewRowCellClassIndexBlock = ^Class(NSIndexPath *indexPath) {
        if (indexPath.section == 1) {
            return MHReportRepairNewEnableEditCell.class;
        }
        return MHReportRepairNewCommonCell.class;
    };
    self.mh_tableViewRowDataBlock = ^(NSIndexPath *indexPath){
        @strongify(self);
        NSArray *arr = self.dataArr[indexPath.section];
        return arr[indexPath.row];
    };
}
@end
