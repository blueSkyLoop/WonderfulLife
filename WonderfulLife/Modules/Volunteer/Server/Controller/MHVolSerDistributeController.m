//
//  MHVolSerDistributeController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerDistributeController.h"

#import "MHVolSerDistributeCell.h"
#import "MHThemeButton.h"
#import "MHAlertView.h"

#import "MHVoServerRequestDataHandler.h"
#import "MHVolSerReviewDistributeTeamModel.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "MHHUDManager.h"

#import "UIViewController+MHConfigControls.h"
#import "UIView+MHFrame.h"
#import "NSMutableAttributedString+MHColor.h"
#import "MHVolSerReviewDetailController.h"

#import <YYText.h>

@interface MHVolSerDistributeController ()
@property (nonatomic, strong) MHThemeButton *commitBtn;
@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectFlags;
@end

@implementation MHVolSerDistributeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self mh_createTitleLabelWithTitle:@"分配服务队"];
    
    NSString *str = [NSString stringWithFormat:@"请将%@分配至具体服务队",self.name];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(2, self.name.length);
    NSValue *value = [NSValue valueWithRange:range];
    [att mh_attributedStringWithColorArray:@[MColorBlue] ranges:@[value]];
    
    self.lab.attributedText = att;
    
    [self.view addSubview:self.lab];
    
    [self mh_createTalbeView];
    self.tableView.rowHeight = 168;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView.mh_h -= ({
        self.tableView.mh_y = 170;
        
    }) + 60;
    
    [self.view addSubview:self.commitBtn];
    
    self.extendedLayoutIncludesOpaqueBars = YES ;
    
    //request
    [self requestGetTeamData];
}

#pragma mark - Reqeust
/** 获取分配服务队 */
- (void)requestGetTeamData {
    [MHHUDManager show];
    [MHVoServerRequestDataHandler getVolunteerTeamListWithApplyId:self.applyId Success:^(NSArray *dataSource){
        [MHHUDManager dismiss];
        
        _dataSource = dataSource;
        [self.tableView reloadData];
        
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

/** 同意 */
- (void)requestAgree {
    [MHHUDManager show];
    if (self.selectFlags.count != 1) return;
    MHVolSerReviewDistributeTeamModel *model = self.selectFlags[0];
    [MHVoServerRequestDataHandler postVolunteerApplyAgreeWithApplyId:self.applyId team_id:model.team_id Success:^{
        [MHHUDManager dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerReviewPageNotification object:nil];
       NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        [self.navigationController popToViewController:self.navigationController.viewControllers[index - 2] animated:YES];
    } failure:^(NSString *errmsg,NSInteger errcode) {
        [MHHUDManager dismiss];
        if (errcode == 1001) {
            [MHHUDManager showText:errmsg Complete:^{
                NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
                MHVolSerReviewDetailController *vc = self.navigationController.viewControllers[index - 1];
                if ([vc isKindOfClass:[MHVolSerReviewDetailController class]]) {
                    !vc.refreshRevokeBlock ? : vc.refreshRevokeBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
        
    }];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVolSerDistributeCell *cell = [MHVolSerDistributeCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.selectBlock = ^(MHVolSerReviewDistributeTeamModel *model, BOOL isSelect){
        if (isSelect) {
            [self.selectFlags addObject:model];
        } else {
            [self.selectFlags removeObject:model];
        }
        if (self.selectFlags.count == 1) {
            self.commitBtn.enabled = YES;
        } else {
            self.commitBtn.enabled = NO;
        }
    };
    return cell;
}

#pragma mark - Event
- (void)shootAction {
    if (self.selectFlags.count != 1) return;
    MHVolSerReviewDistributeTeamModel *model = self.selectFlags[0];
    NSString *message = [NSString stringWithFormat:@"确定将%@配属到\n%@？",self.name, model.team_name];
    [[MHAlertView sharedInstance] showNormalAlertViewTitle:message message:nil leftHandler:^{
        
    } rightHandler:^{
        //request
        [self requestAgree];
    } rightButtonColor:nil];
}

#pragma mark - Getter
- (MHThemeButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW , 60)];
        [_commitBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(shootAction) forControlEvents:UIControlEventTouchDown];
        _commitBtn.layer.masksToBounds = NO;
        _commitBtn.enabled = NO;
    }
    return _commitBtn;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [UILabel new];
        _lab.frame = CGRectMake(0, 136, MScreenW, 17);
        _lab.textColor = MColorContent;
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = MFont(17);
    }
    return _lab;
}

- (NSMutableArray *)selectFlags {
    if (!_selectFlags) {
        _selectFlags = [NSMutableArray array];
    }
    return _selectFlags;
}
@end
