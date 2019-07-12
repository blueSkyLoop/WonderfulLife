//
//  MHActivityModifyController.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityModifyController.h"
#import "MHVolActivityConfigurationInfoSelectController.h"
#import "MHActivityModifyContainerView.h"
#import "MHActivityActionView.h"

#import "MHAlertView.h"
#import "MHHUDManager.h"
#import "MHActivityModifyPeoplesCell.h"
#import "MHActivityModifyOnlyTextCell.h"
#import "MHActivityModifyRulesEditCell.h"
#import "MHActivityModifyTextAndIconCell.h"
#import "MHActivityModifyIntroduceEditCell.h"

#import "MHActivityModifyViewModel.h"
#import "MHActivityPublishViewModel.h"
#import "MHActivityModifyBaseViewModel.h"

#import "Masonry.h"
#import "MHConst.h"
#import "MHMacros.h"
#import "UIView+MHFrame.h"
#import "UIViewController+MHConfigControls.h"

@interface MHVolActivityModifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong ,nonatomic) MHActivityModifyBaseViewModel  *viewModel;
@property (strong ,nonatomic) MHActivityActionView           *actionView;
@property (assign ,nonatomic) MHActivityActionViewType        actionType;
@end

@implementation MHVolActivityModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor     = MColorBackgroud;
    
    [self mh_createTalbeViewStyleGrouped];
    [self mh_initTitleAlignmentLeftLabelWithTitle:@"活动类型"];
    self.lineAlpha = 0;
    
    self.tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 72;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    
    self.viewModel.controller = self;
    [MHHUDManager show];
    self.viewModel.activity_team_id = self.activity_team_id;
    [self.viewModel.pullDisplayDatasCommand execute:nil];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-95);
    }];
    
    self.actionView = [MHActivityActionView activityActionViewWithStatus:_actionType qty:0 sty:0 handler:^{
        if (self.type == MHActivityModifyTypeNormal) {
            [MHHUDManager show];
            [self.viewModel.updateModifyDatasCommand execute:nil];
        }else {
            [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确认发布该活动" leftHandler:^(void){
                [[MHAlertView sharedInstance]dismiss];
            } rightHandler:^(void){
                [MHHUDManager show];
                [self.viewModel.updateModifyDatasCommand execute:nil];
            } rightButtonColor:nil];
        }
    }];
    self.actionView.frame = CGRectMake(0, MScreenH - 95, MScreenW, 95);
    [self.view addSubview:self.actionView];
    
    
    @weakify(self);
    [self.viewModel.reloadDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MHHUDManager dismiss];
        [self.tableView reloadData];
        [self updateBottomButton];
    }];
    
}

- (void)setType:(MHActivityModifyType)type {
    _type = type;
    if (type == MHActivityModifyTypeNormal) {
        _viewModel = [[MHActivityModifyViewModel alloc]init];
        _viewModel.action_id = self.action_id;
        _actionType = MHActivityActionViewTypeRepairDisabled;
    }else {
        _viewModel = [[MHActivityPublishViewModel alloc]init];
        _viewModel.vol_team_id = self.team_id;
        _viewModel.vol_team_name = self.team_name;
        _actionType = MHActivityActionViewTypeActivityPublishDisabled;
    }
}

- (void)updateBottomButton {
    NSUInteger count = [self.viewModel.postDatas allKeys].count;
    MHActivityActionViewType type = MHActivityActionViewTypeRepairNormal;
    if (count == 0 &&self.type == MHActivityModifyTypeNormal) { //该条件只适用于修改活动功能
        type = MHActivityActionViewTypeRepairDisabled;
    }
    
    if (self.type == MHActivityModifyTypePublish) {//该条件只适用于发布活动功能
        __block BOOL isEnableCommit = YES;
        type = MHActivityActionViewTypeActivityPublishDisabled;
        [self.viewModel.dataSources enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *content = obj[@"content"];
            if ([content isEqualToString:@"必填"]) {
                isEnableCommit = NO;
            }
        }];
        
        if (isEnableCommit) {
            type = MHActivityActionViewTypeActivityPublish;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.actionView setConfigWithType:type qty:0 sty:0];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.viewModel.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MHActivityModifyIntroduceEditCell *cell = [MHActivityModifyIntroduceEditCell cellWithTableView:tableView];
        cell.introduce = self.viewModel.activityIntroduce;
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self);
            [self.viewModel.modifyIntroduceSubject sendNext:nil];
        };
        return cell;
    }else if (indexPath.section == 1) {
        NSDictionary *model = self.viewModel.dataSources[indexPath.row];
        if (indexPath.row == 0 || indexPath.row == 5) {
            MHActivityModifyOnlyTextCell *cell = [MHActivityModifyOnlyTextCell cellWithTableView:tableView];
            cell.boldFont = indexPath.row == 0;
            cell.model = model;
            return cell;
        }else if (indexPath.row == 1) {
            MHActivityModifyPeoplesCell *cell = [MHActivityModifyPeoplesCell cellWithTableView:tableView];
            cell.model = model;
            @weakify(self);
            cell.clickBlock = ^(NSInteger selectedNumber) {
                @strongify(self);
                [self.viewModel.modifyPeoplesSubject sendNext:@(selectedNumber)];
                [self updateBottomButton];
            };
            return cell;
        }else if (indexPath.row == 2||indexPath.row ==3||indexPath.row ==4) {
            MHActivityModifyTextAndIconCell *cell = [MHActivityModifyTextAndIconCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }else if (indexPath.row == 6){
            MHActivityModifyRulesEditCell *cell = [MHActivityModifyRulesEditCell cellWithTableView:tableView];
            cell.text = self.viewModel.activityRule;
            @weakify(self);
            cell.clickBlock = ^{
                @strongify(self);
                [self.viewModel.modifyRulesSubject sendNext:nil];
            };
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0&&self.type == MHActivityModifyTypePublish ) { //如果是发布功能，则加大高度以适应控件
        return 124.f;
    }
    return 72.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == MHActivityModifyTypeNormal) {
            return [MHActivityModifyContainerView initSection0View:self.viewModel.activityTitle];
        }else if(self.type == MHActivityModifyTypePublish){
            @weakify(self);
            return [MHActivityModifyContainerView initSectionPublishView:self.viewModel.activityTitle block:^{
               MHVolActivityConfigurationInfoSelectController *controller = [MHVolActivityConfigurationInfoSelectController new];
                @strongify(self);
                controller.teamID = self.team_id;
                controller.type = MHVolActivityConfigurationInfoSelectTypeProject;
                controller.block = ^(NSNumber *action_template_id, NSString *title) {
                    self.viewModel.activity_template_id = action_template_id;
                    self.viewModel.activityTitle        = title;
                    [MHHUDManager show];
                    [self.viewModel.pullDisplayDatasCommand execute:nil];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
    }
    return [MHActivityModifyContainerView initSection1View];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabel];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self mh_scrollUpdateTitleLabel];
}


@end
