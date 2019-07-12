//
//  MHReportRepairDetailDelegateModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailDelegateModel.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "LCommonModel.h"

#import "MHReportRepairDetailProgressCell.h"
#import "MHReportRepairDetailCell.h"
#import "XHStarRateView.h"

@implementation MHReportRepairDetailDelegateModel

- (void)mh_delegateConfig{
    @weakify(self);
    self.mh_tableViewRowsNumBlock = ^NSInteger(NSInteger section) {
        @strongify(self);
        NSArray *arr = self.dataArr[section];
        return arr.count;
    };
    
    self.mh_tableViewRowCellClassIndexBlock = ^Class(NSIndexPath *indexPath) {
        @strongify(self);
        NSArray *arr = self.dataArr[indexPath.section];
        if([[arr firstObject] isKindOfClass:NSClassFromString(@"MHReportRepairLogModel")]){
            return NSClassFromString(@"MHReportRepairDetailProgressCell");
        }
        
        return NSClassFromString(@"MHReportRepairDetailCell");
    };
    
    self.mh_tableViewRowDataBlock = ^id(NSIndexPath *indexPath) {
        @strongify(self);
        NSArray *arr = self.dataArr[indexPath.section];
        return arr[indexPath.row];
    };
    self.mh_tableViewRowCellBlock = ^(NSIndexPath *indexPath,UITableViewCell<MHCellConfigDelegate> *acell){
        @strongify(self);
        NSArray *arr = self.dataArr[indexPath.section];
        if([[arr firstObject] isKindOfClass:NSClassFromString(@"MHReportRepairLogModel")]){
            MHReportRepairDetailProgressCell *cell = (MHReportRepairDetailProgressCell *)acell;
            if(indexPath.row == arr.count - 1){
                cell.bottomLineView.hidden = NO;
            }else{
                cell.bottomLineView.hidden = YES;
            }
        }else{
            MHReportRepairDetailCell *cell = (MHReportRepairDetailCell *)acell;
            cell.pictureView.pictreCollectionViewDidSelectBlock = self.pictreCollectionViewDidSelectBlock;
        }
    };
    
    self.weakTableView.sectionFooterHeight = 16;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return 64 + 32;
    }
    if(self.model.status == 2 && section == 1){
        return 56;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return [self progressHeadView];
    }
    if(self.model.status == 2 && section == 1){
        return [self evaluateHeadView];
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 16)];
    footView.backgroundColor = MColorBackgroud;
    return footView;
}

#pragma mark - headView
- (UIView *)progressHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 64 + 32)];
    headView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [UIView new];
    topView.backgroundColor = MColorBackgroud;
    [headView addSubview:topView];
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = MRGBColor(211, 220, 230);
    UIView *bottomLine = [[UIView alloc] init];;
    bottomLine.backgroundColor = MRGBColor(211, 220, 230);
    UILabel *atitleLabel = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MRGBColor(50, 64, 87)];
    atitleLabel.text = @"处理进度";
    UILabel *stateLabel = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MRGBColor(71, 86, 105)];
    //待处理和处理中的状态
    if(self.model.status == 0 || self.model.status == 1 || self.model.status == 4){
        stateLabel.textColor = MRGBColor(32, 160, 255);
    }
    stateLabel.text = self.model.status_name;
    UIView *bgView = [UIView new];
    [headView addSubview:topLine];
    [headView addSubview:bottomLine];
    [bgView addSubview:atitleLabel];
    [bgView addSubview:stateLabel];
    [headView addSubview:bgView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headView);
        make.height.equalTo(@16);
    }];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(16);
        make.left.right.equalTo(headView);
        make.height.equalTo(@.5);
    }];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.top.equalTo(topLine.mas_bottom);
        make.height.equalTo(@48);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom);
        make.left.right.equalTo(headView);
        make.bottom.equalTo(headView.mas_bottom).offset(-32).priorityLow();
        make.height.equalTo(@1);
    }];
    [atitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView.mas_left).offset(16);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(atitleLabel.mas_centerY);
        make.left.greaterThanOrEqualTo(atitleLabel.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-16);
    }];
    return headView;
}
- (UIView *)evaluateHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 56)];
    headView.backgroundColor = [UIColor whiteColor];
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(16, 20, 16 * 5 + 6 * 4, 16) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:^(CGFloat currentScore) {
    }];
    starRateView.userInteractionEnabled = NO;
    if(self.model.is_evaluate){
        [starRateView setCurrentScore:self.model.evaluate_level];
    }
    UILabel *stateLabel = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MRGBColor(71, 86, 105)];
    stateLabel.text = self.model.is_evaluate?@"已评价":@"去评价";
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = MRGBColor(211, 220, 230);
    UIView *bottomLine = [[UIView alloc] init];;
    bottomLine.backgroundColor = MRGBColor(211, 220, 230);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
    [headView addSubview:imageView];
    [headView addSubview:starRateView];
    [headView addSubview:stateLabel];
    [headView addSubview:topLine];
    [headView addSubview:bottomLine];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.greaterThanOrEqualTo(headView.mas_left).offset(50);
    }];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(headView);
        make.height.equalTo(@.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headView);
        make.height.equalTo(@.5);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(stateLabel.mas_right).offset(11);
        make.right.equalTo(headView.mas_right).offset(-16);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[[tap rac_gestureSignal] throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if(self.evaluateBlock){
            self.evaluateBlock();
        }
    }];
    [headView addGestureRecognizer:tap];
    return headView;
}

@end
