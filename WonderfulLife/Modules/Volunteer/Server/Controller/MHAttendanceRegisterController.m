//
//  MHAttendanceRegisterController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAttendanceRegisterController.h"
#import "MHVoSeAttendanceRecordController.h"

#import "MHVoSeMonStepperButtonView.h"
#import "MHVoSeAttendanceRegisterCell.h"
#import "MHThemeButton.h"
#import "MHAlertView.h"
#import "MHHUDManager.h"

#import "MHVoServerRequestDataHandler.h"

#import "MHNavigationControllerManager.h"

//#import "HLNavigationPopProtocol.h"
#import "UIViewController+MHConfigControls.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import "YYModel.h"
@interface MHAttendanceRegisterController () <MHNavigationControllerManagerProtocol>
@property (nonatomic, strong) MHVoSeMonStepperButtonView *monBtnView;
@property (nonatomic, strong) MHThemeButton *commitBtn;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *commitModel;
@property (nonatomic,copy) NSString *remarks;

@end

@implementation MHAttendanceRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addControls];
    [self layoutControls];
    
    //request
    [self requestMemberListData];
}

- (void)addControls {
    
    [self mh_createTitleLabelWithTitle:@"登记考勤"];
    [self.view addSubview:self.monBtnView];
    [self mh_createTalbeView];
    self.tableView.rowHeight = 80;
    
    [self.view addSubview:self.commitBtn];
}
- (void)layoutControls {
    self.tableView.mh_y = 232;
    self.tableView.mh_h = MScreenH - self.tableView.mh_y - self.commitBtn.mh_h ;
    self.monBtnView.mh_y = 144;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
}


- (BOOL)bb_ShouldBack{
    if (self.commitBtn.enabled == YES) {
        UINavigationController *nav = self.navigationController;
        if ([nav.viewControllers.lastObject class] == [self class]) {
            [[MHAlertView sharedInstance] showNormalAlertViewTitle:@"放弃当前编辑" message:@"放弃操作将清除当前编辑内容" leftHandler:^{
            } rightHandler:^{
                [self.navigationController popViewControllerAnimated:YES];
            }rightButtonColor:nil];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Request
- (void)requestMemberListData {
    [MHHUDManager show];
    [MHVoServerRequestDataHandler
     getVolunteervCheckinteamMemberListtWithId:self.teamId
     type:self.type
     Success:^(NSArray<MHVolSerReamListModel *> *dataSource)
     {
         [MHHUDManager dismiss];
         self.dataSource = dataSource;
         [self.tableView reloadData];
     } failure:^(NSString *errmsg) {
         [MHHUDManager dismiss];
     }];
}

- (void)requestCommitData {
    NSString *details = [self.commitModel yy_modelToJSONString];
    
    [MHHUDManager show];
    [MHVoServerRequestDataHandler
     postVolunteervCheckinSaveWithId:self.teamId
     type:self.type activity_item_id:self.activity_item_id
     attendance_date:self.monBtnView.date
     attendance_details:details
     success:^{
         MHVoSeAttendanceRecordController *vc = [[MHVoSeAttendanceRecordController alloc] init];
         vc.teamId = self.teamId;
         vc.id_type = self.type;
         [self.navigationController pushViewController:vc animated:NO];
         
         [MHHUDManager dismiss];
         [MHHUDManager showText:@"考勤记录已经提交成功"];
     } failure:^(NSString *errmsg) {
         [MHHUDManager dismiss];
     }];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVoSeAttendanceRegisterCell *cell = [MHVoSeAttendanceRegisterCell cellWithTableView:tableView];
    MHVolSerReamListModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.attendance_details = self.commitModel;
    __weak typeof(self) wself = self;
    cell.enableCommitButtonBlock = ^(BOOL enable){
        wself.commitBtn.enabled = enable;
    };
    return cell;
}

#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = MColorToRGB(0XF9FAFC);
        
        UILabel *l1 = [[UILabel alloc] init];
        l1.frame = CGRectMake(60, 48/2 - 17/2.0, 80, 17);
        l1.text = @"队员名单";
        l1.textColor = MColorTitle;
        [v addSubview:l1];
        
        UILabel *l2 = [[UILabel alloc] init];
        l2.frame = CGRectMake(MScreenW - 114, 48/2 - 17/2.0, 50, 17);
        l2.text = @"时长";
        l2.textColor = MColorTitle;
        l2.textAlignment = NSTextAlignmentCenter;
        [v addSubview:l2];
        
        return v;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

#pragma mark - Event
- (void)commitAction {
    [[MHAlertView sharedInstance] showNormalAlertViewTitle:@"提交考勤" message:@"考勤记录将上传给社区文化专员审核有任何修改请及时联系专员" leftHandler:^{
    } rightHandler:^{
        [self requestCommitData];
    } rightButtonColor:nil];
}
#pragma mark - Getter
- (MHVoSeMonStepperButtonView *)monBtnView {
    if (!_monBtnView) {
        _monBtnView = [MHVoSeMonStepperButtonView voSeMonStepperButtonViewWithType:MHVoSeMonStepperButtonViewDay];
    }
    return _monBtnView;
}

- (MHThemeButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_commitBtn setTitle:@"提 交" forState:UIControlStateNormal];
        _commitBtn.layer.masksToBounds = NO;
        _commitBtn.enabled = NO;
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(0, 64, MScreenW, 34);
        _titleLab.textColor = MColorTitle;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = MFont(34);
    }
    return _titleLab;
}

- (NSMutableArray *)commitModel {
    if (!_commitModel) {
        _commitModel = [NSMutableArray array];
    }
    return _commitModel;
}
@end


