//
//  MHHomeMyRoomController.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayMyRoomController.h"
#import "MHLoSetPlotController.h"
#import "MHHomePayNoteController.h"

#import "MHMacros.h"
#import "MHNavigationControllerManager.h"
#import "UIViewController+HLStoryBoard.h"
#import "UIImage+Color.h"
#import "MHHUDManager.h"
#import "MHWeakStrongDefine.h"
#import "ReactiveObjC.h"
#import <Masonry.h>

#import "MHHomePayDetailsHeaderView.h"
#import "MHHomePayMyRoomCell.h"
#import "MHHomeRequest.h"
#import "MHHomeRoomModel.h"
#import "YYModel.h"
#import "MHMineRoomViewModel.h"
#import "MHMineRoomModel.h"

#import "UIViewController+HLNavigation.h"

#import "MHUserInfoManager.h"

// cell重用标识
static NSString *myRoomCellID = @"myRoomCell";

@interface MHHomePayMyRoomController () <UITableViewDataSource, UITableViewDelegate,MHHomePayMyRoomCellDelegate>
/**
 tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MHMineRoomViewModel *roomListViewModel;
@property (strong, nonatomic) MHHomePayDetailsHeaderView *headerView;
@end

@implementation MHHomePayMyRoomController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置导航栏
    self.navigationController.navigationBarHidden = NO;
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:[UIColor whiteColor]];
    
}

- (MHMineRoomViewModel *)roomListViewModel{
    if (_roomListViewModel == nil) {
        _roomListViewModel = [MHMineRoomViewModel new];
    }
    return _roomListViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    [self loadData];
    @weakify(self)
    [self setRefreshDataList:^{
        @strongify(self)
        [self refreshController];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshController) name:@"com.mh.myroom.refresh" object:nil];
}


- (void)refreshController {
   
    [self.roomListViewModel.roomListCommand execute:nil];
}

- (void)loadData{
    if (self.type == MHHomePayMyRoomControllerTypePay) {
        self.headerView.titleLabel.text = @"切换缴费房间";
    }
    
    [[self.roomListViewModel.roomListCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        [MHHUDManager dismiss];
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;
        [MHHUDManager dismiss];
        if ([isSuccess boolValue]) {
            [self.dataList removeAllObjects];
            self.dataList = [NSMutableArray arrayWithArray:datas];
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:datas];
        }
    }];
    [MHHUDManager show];
    [self.roomListViewModel.roomListCommand execute:nil];
}

#pragma mark - 设置tableView
- (void)setupTableView {
    
    // 1. 注册cell
    UINib *nib = [UINib nibWithNibName:@"MHHomePayMyRoomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:myRoomCellID];
    
    // 2. 设置tableView头部视图
    self.headerView = [MHHomePayDetailsHeaderView loadHomePayDetailsHeaderView];
    self.headerView.frame = CGRectMake(0, 0, MScreenW, 60);
    self.headerView.bottomLine.hidden = YES;
    self.headerView.titleLabel.text = @"我的房间";
    [self.view addSubview:self.headerView];
    
    // 3. 设置tableView尾部视图
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 1;
    button.layer.borderColor = MColorToRGB(0X20A0FF).CGColor;
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button.titleLabel setFont:[UIFont systemFontOfSize:19.0]];
    [button setTitle:@"添加房间" forState:UIControlStateNormal];
    [button setTitleColor:MColorToRGB(0X20A0FF) forState:UIControlStateNormal];
    [button setTitleColor:MColorToRGB(0X20A0FF) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(footerViewAddRoomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(56);
    }];
}

#pragma mark - 添加房间
- (void)footerViewAddRoomClick:(UIButton *)button {
    MHLoSetPlotController *loSetVc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:@"MHLoSetPlotController"];
    loSetVc.setType = MHLoSetPlotTypeCertifi;
    [self.navigationController pushViewController:loSetVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 获取cell
    MHHomePayMyRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:myRoomCellID forIndexPath:indexPath];
    cell.isHiddenArrow = self.type != MHHomePayMyRoomControllerTypePay;
    MHMineRoomModel *model = self.dataList[indexPath.row];
    cell.mineRoomModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == MHHomePayMyRoomControllerTypePay) {
        MHMineRoomModel *model = self.dataList[indexPath.row];
        if (![model.audit_status isEqualToNumber:@2]) {
            [MHHUDManager showErrorText:@"只能选择已认证房间进行缴费"];
            return;
        }
        
        NSInteger index = self.navigationController.viewControllers.count - 2;
        MHHomePayNoteController *vc = self.navigationController.viewControllers[index];
        vc.room = model;
        vc.refreshBillBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MHHomePayMyRoomCellDelegate
- (void)removeRoomWithIndexPath:(NSIndexPath *)indexPath PropertyID:(NSString *)property_id{
    [MHHUDManager show];
    [MHHomeRequest postPropertyfeeDeleteWithPropertyID:property_id Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success ) {
            
            [self.dataList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.dataList enumerateObjectsUsingBlock:^(MHHomeRoomModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            }];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end


