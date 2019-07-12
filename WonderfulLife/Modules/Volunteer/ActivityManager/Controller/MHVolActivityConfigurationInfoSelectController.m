//
//  MHVolActivityTeamsSelectController.m
//  WonderfulLife
//
//  Created by zz on 16/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityConfigurationInfoSelectController.h"
#import "MHVolActivityModifyController.h"
#import "MHUserInfoManager.h"
#import "MHVolActivityRequestHandler.h"
#import "MHVolActivityTeamsSelectCell.h"
#import "MHHUDManager.h"
#import "MHWeakStrongDefine.h"
#import "MHAlertView.h"
#import "UIViewController+MHConfigControls.h"
#import "MHVolunteerUserInfo.h"

@interface MHVolActivityConfigurationInfoSelectController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray *dataSource;
@end

@implementation MHVolActivityConfigurationInfoSelectController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self mh_createTalbeView];

    MHWeakify(self);
    
    NSNumber *volunteer_id = [MHVolunteerUserInfo sharedInstance].volunteer_id;
    NSString *title;
    
    if (self.type == MHVolActivityConfigurationInfoSelectTypeTeams) {
        title = @"选择服务队";
        [MHVolActivityRequestHandler pullActivityTeamListWithVolunteer_id:volunteer_id ActivityDetailsBlock:^(id model) {
            MHStrongify(self);
            [MHHUDManager dismiss];
            self.dataSource = model;
            [self.tableView reloadData];
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    }else {
        title = @"选择活动类型";

        [MHVolActivityRequestHandler pullActivityTypeListWithVolunteer_id:volunteer_id teamID:self.teamID ActivityDetailsBlock:^(id model, BOOL isSuccess) {
            MHStrongify(self);
            [MHHUDManager dismiss];
            self.dataSource = model;
            [self.tableView reloadData];
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    }
    [self mh_initTitleAlignmentLeftLabelWithTitle:title];
    self.lineAlpha = 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVolActivityTeamsSelectCell *cell = [MHVolActivityTeamsSelectCell cellWithTableView:tableView];
    NSDictionary *dic = self.dataSource[indexPath.row];
    if (self.type == MHVolActivityConfigurationInfoSelectTypeTeams) {
        cell.teamNameLabel.text = dic[@"team_name"];
    }else {
        cell.teamNameLabel.text = dic[@"title"];
        cell.arrowImageView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    if (![dic[@"has_action_template"] boolValue]&&self.type == MHVolActivityConfigurationInfoSelectTypeTeams) {

        [MHAlertView showMessageAlertViewMessage:@"未配置活动模板，不可发布\n请联系文化专员" sureHandler:^{
            
        }];
        
        return;
    }
    
    if (self.type == MHVolActivityConfigurationInfoSelectTypeTeams) {
        
        MHVolActivityModifyController *controller = [[MHVolActivityModifyController alloc]init];
        controller.team_id = dic[@"team_id"];
        controller.team_name = dic[@"team_name"];
        controller.type = MHActivityModifyTypePublish;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        if (self.block) {
            self.block(dic[@"action_template_id"], dic[@"title"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
