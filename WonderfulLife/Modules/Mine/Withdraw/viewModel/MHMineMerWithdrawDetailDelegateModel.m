//
//  MHMineMerWithdrawDetailDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawDetailDelegateModel.h"
#import "MHMineMerWithdrawFinanceReocrdHeadView.h"

@implementation MHMineMerWithdrawDetailDelegateModel

- (void)mh_delegateConfig{
    [self.weakTableView registerClass:[MHMineMerWithdrawFinanceReocrdHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass(MHMineMerWithdrawFinanceReocrdHeadView.class)];
    self.weakTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.weakTableView.estimatedSectionHeaderHeight = 60.f;
    if ([self.weakTableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.weakTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.weakTableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.weakTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.dataArr.count == 0){
        return nil;
    }
    MHMineMerWithdrawFinanceReocrdHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MHMineMerWithdrawFinanceReocrdHeadView.class)];
    return headView;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
