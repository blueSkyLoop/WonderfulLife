//
//  MHVoSerTeamController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerTeamController.h"
#import "MHVolSerDetailController.h"
#import "MHVoSerCheckTimeController.h"
#import "MHVolSerItemController.h"
#import "MHGcTableController.h"

/** 全队考勤*/
#import "MHVoSeAttendanceRecordController.h"

/** 登记考勤*/
#import "MHAttendanceRegisterController.h"


#import "MHVoSerUnJoinTeamCell.h"
#import "MHVoSerJoinedTeamCell.h"
#import "MHVolMyTeamTableFootView.h"
#import "MHVoSerJoinedTeamPublicCell.h"

#import "MHVoSerTeamManager.h"
#import "MHVolSerTeamRequest.h"
#import "MHVolSerTeamModel.h"
#import "MHVolSerReamListModel.h"
#import "MHVoServerRequestDataHandler.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import <UIViewController+HLNavigation.h>
#import "NSObject+isNull.h"
#import "MHConst.h"

@interface MHVoSerTeamController () <UITableViewDelegate,UITableViewDataSource,MHVoSerJoinedTeamDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerContentView;


@property (strong,nonatomic) MHVoSerTeamManager *manager;

@end

@implementation MHVoSerTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVoSerUnJoinTeamCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVoSerUnJoinTeamCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVoSerJoinedTeamPublicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVoSerJoinedTeamPublicCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVoSerJoinedTeamCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVoSerJoinedTeamCell class])];
    [self request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:kReloadVoSerTeamNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  Request
- (void)request{
    [MHHUDManager show];
    [MHVolSerTeamRequest loadVolSerTeamWithCallBack:^(BOOL success, id  info) {
        [MHHUDManager dismiss];
        if (success) {
            self.manager = info;
            [self.tableView reloadData];
            if (self.manager.isShowJoinBtn) {
                NSString *titleStr = self.manager.teams.count  ? @"申请加入其他服务项目" : @"申请加入服务项目";
                self.tableView.tableFooterView = [MHVolMyTeamTableFootView viewWithBtnTitle:titleStr buttonAction:^{
                    MHVolSerItemController * vc = [[MHVolSerItemController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            } else {
                self.tableView.tableFooterView = [MHVolMyTeamTableFootView viewWithOutButton];
            }
            if (self.manager.teams.count) {
                self.tableView.tableHeaderView = nil;
            } else {
                
                self.headerContentView.layer.masksToBounds = YES;
                self.headerContentView.layer.cornerRadius = 6;
                self.headerContentView.layer.borderColor = MColorSeparator.CGColor;
                self.headerContentView.layer.borderWidth = 1;
                
                self.tableView.tableHeaderView = self.headerView;
            }
        } else {
            [MHHUDManager showErrorText:info];
        }
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.teams.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVolSerTeamModel *model = self.manager.teams[indexPath.row];
    if (model.type==MHVolSerTeamUnPass || model.type==MHVolSerTeamApproving) {
        return 184;
    } else {
        return 230;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVolSerTeamModel *model = self.manager.teams[indexPath.row];
    if (model.type==MHVolSerTeamUnPass || model.type==MHVolSerTeamApproving || model.type == MHVolSerTeamWithdraw) {
        MHVoSerUnJoinTeamCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVoSerUnJoinTeamCell class])];
        cell.model = model;
        return cell;
    } else {
        
        if (model.activity_type == 0) {
            MHVoSerJoinedTeamPublicCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVoSerJoinedTeamPublicCell class])];
            cell.model = model;
            return cell;

        }else{
            MHVoSerJoinedTeamCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVoSerJoinedTeamCell class])];
            cell.delegate = self;
            cell.model = model;
            cell.indexPath = indexPath;
             return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVolSerTeamModel *model = self.manager.teams[indexPath.row];
    NSNumber *idNum = model.team_id ;
    MHVolSerDetailType detailType = MHVolSerDetailTypeTeam ;
    if ([NSObject isNull:idNum]) {
        idNum = model.project_id;
        detailType = MHVolSerDetailTypeItem;
    }
    MHVolSerDetailController *vc = [[MHVolSerDetailController alloc]init];
    vc.type = detailType;
    vc.detailId = idNum;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MHVoSerJoinedTeamDelegate

//我的考勤
- (void)didClickMyAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath {
    MHVoSerCheckTimeController *vc = [[MHVoSerCheckTimeController alloc]initWithType:MHVolCheckTimeChecking];
    /* 奇葩逻辑
     如果是 队员 | 队长    的话， 就使用 team_id
     id_type = @"t";
     
     如果是 总队长的话，就使用  project_id
     id_type = @"a";
     */
    NSNumber *idNum = self.manager.teams[indexPath.row].team_id ;
    NSString *typeStr ;
    if (![NSObject isNull:idNum]) {
        typeStr = @"t";
    }else{
        idNum = self.manager.teams[indexPath.row].project_id;
        typeStr = @"a";
    }
    vc.idNum = idNum;
    vc.id_type = typeStr;
    [self.navigationController pushViewController:vc animated:YES];
}

// 全队考勤
- (void)didClickAllAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *idNum = self.manager.teams[indexPath.row].team_id ;
    NSString *typeStr ;
    if (![NSObject isNull:idNum]) {
        typeStr = @"t";
    }else{
        idNum = self.manager.teams[indexPath.row].project_id;
        typeStr = @"a";
    }
    
    MHVoSeAttendanceRecordController *vc = [[MHVoSeAttendanceRecordController alloc] init];
    vc.teamId = idNum;
    vc.id_type = typeStr;
    [self.navigationController pushViewController:vc animated:YES];
}

// 登记考勤
//- (void)didClickRegistAttendanceButtonAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *idNum = self.manager.teams[indexPath.row].team_id ;
//    NSString *typeStr ;
//    if (![NSObject isNull:idNum]) {
//        typeStr = @"t";
//    }else{
//        idNum = self.manager.teams[indexPath.row].project_id;
//        typeStr = @"a";
//    }
//    
//    //request
//    [MHVoServerRequestDataHandler getVolunteervCheckinActivityItemListWithId:idNum
//                                                                        type:typeStr
//                                                                     Success:^(NSArray<MHVolSerReamListModel *> *dataSource)
//     {
//         NSMutableArray *arrayModel = @[].mutableCopy;
//         [dataSource enumerateObjectsUsingBlock:^(MHVolSerReamListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//             MHGcTableModel *model = [MHGcTableModel new];
//             model.title = obj.name;
//             model.teamId = obj.id;
//             [arrayModel addObject:model];
//         }];
//         
//         MHGcTableController *vc = [[MHGcTableController alloc] init];
//         vc.titleStr = @"选择考勤类型";
//         vc.dataSource = arrayModel;
//         vc.didSelectBlock = ^(MHGcTableModel *model){
//             MHAttendanceRegisterController *vc = [[MHAttendanceRegisterController alloc] init];
//             vc.teamId = idNum;
//             vc.activity_item_id = model.teamId;
//             vc.type = typeStr;
//             [self.navigationController pushViewController:vc animated:YES];
//         };
//         [self.navigationController pushViewController:vc animated:YES];
//     } failure:^(NSString *errmsg) {
//         
//     }];
//    
//}



@end
