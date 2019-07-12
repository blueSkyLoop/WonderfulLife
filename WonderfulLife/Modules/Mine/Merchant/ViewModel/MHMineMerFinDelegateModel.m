//
//  MHMineMerFinDelegateModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/11/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinDelegateModel.h"
#import "MHMacros.h"
@implementation MHMineMerFinDelegateModel


- (void)mh_delegateConfig{
     [self.weakTableView setTableHeaderView:self.headView];
    self.weakTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mh_tableViewRowCellBlock = ^(NSIndexPath *indexPath, UITableViewCell<MHCellConfigDelegate> *acell) {
        
    };
    self.weakTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (MHMineMerFinHeaderView *)headView {
    if (!_headView) {
        _headView = [MHMineMerFinHeaderView mineMerfinHeaderViewWithFrame:CGRectMake(0, 0, MScreenW, 370)];
    }return _headView ;
}

@end
