//
//  MHStoreRefundDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundDelegateModel.h"

#import "ReactiveObjC.h"

#import "MHStoreRefundReasonCell.h"
#import "MHStoreRefundOrderInforCell.h"
#import "MHStoreRefundRemarkCell.h"
#import "MHStoreRefundHeaderView.h"

@implementation MHStoreRefundDelegateModel

- (void)mh_delegateConfig{
    @weakify(self);
    self.mh_tableViewRowsNumBlock = ^NSInteger(NSInteger section) {
        @strongify(self);
        NSArray *arr = self.dataArr[section];
        return arr.count;
    };
    self.mh_tableViewRowDataBlock = ^id(NSIndexPath *indexPath) {
        @strongify(self);
        NSArray *arr = self.dataArr[indexPath.section];
        return arr[indexPath.row];
    };
    self.mh_tableViewRowCellClassIndexBlock = ^Class(NSIndexPath *indexPath) {
        if(indexPath.section == 0){
            return MHStoreRefundOrderInforCell.class;
        }else if(indexPath.section == 1){
            return MHStoreRefundReasonCell.class;
        }
        return MHStoreRefundRemarkCell.class;
    };
    self.mh_tableViewRowCellBlock = ^(NSIndexPath *indexPath, UITableViewCell<MHCellConfigDelegate> *acell) {
        if(indexPath.section == 1){
            @strongify(self);
            MHStoreRefundReasonCell *cell = (MHStoreRefundReasonCell *)acell;
            NSArray *arr = self.dataArr[indexPath.section];
            if(arr.count - 1 == indexPath.row){
                cell.bottomLineView.hidden = YES;
            }else{
                cell.bottomLineView.hidden = NO;
            }
        }
    };
    //有多少组
    self.mh_tableViewSectionNumBlock = ^NSInteger{
        @strongify(self);
        return self.dataArr.count;
    };
    
    self.weakTableView.sectionFooterHeight = 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }
    
    MHStoreRefundHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MHStoreRefundHeaderView.class)];
    if(section == 1){
        headView.nameLabel.text = @"退款理由";
        headView.instructionLabel.text = @"（至少选择一项）";
    }else if(section == 2){
        headView.nameLabel.text = @"退款说明";
        headView.instructionLabel.text = @"（必须填）";
    }
    return headView;
}

@end
