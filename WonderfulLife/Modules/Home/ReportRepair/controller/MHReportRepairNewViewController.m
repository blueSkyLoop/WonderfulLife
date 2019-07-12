//
//  MHReportRepairNewViewController.m
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewViewController.h"
#import "MHReportRepairTypeViewController.h"
#import "MHReportRepairMainViewController.h"
#import "MHLoSetPlotController.h"

#import "MHReportRepairNewCommonCell.h"
#import "MHReportRepairNewEnableEditCell.h"
#import "MHThemeButton.h"
#import "MHHUDManager.h"

#import "MHReportRepairNewDelegateModel.h"
#import "MHReportRepairNewViewModel.h"
#import "MHReportRepairNewModel.h"

#import "Masonry.h"

#import "UIViewController+HLStoryBoard.h"

@interface MHReportRepairNewViewController ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MHThemeButton *bottomButton;
@property (nonatomic,strong) MHReportRepairNewDelegateModel *delegateModel;
@property (nonatomic,strong) MHReportRepairNewViewModel *viewModel;
@end

@implementation MHReportRepairNewViewController

#pragma mark - Life Cycle
- (void)dealloc {
    NSLog(@"%s",__func__);
    [MHReportRepairNewModel clear];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewModel = [MHReportRepairNewViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RAC(self, title) = RACObserve(self.viewModel, controllerTitle);
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomButton];
    [self bindViewModel];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-60);
    }];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    RAC(self.bottomButton,enabled) = RACObserve(self.viewModel, isEnableSubmit);
    [self.bottomButton addTarget:self action:@selector(submitRepairInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewModel.reportNewGetRoomInfoCommand execute:nil];
}

- (void)bindViewModel {
    @weakify(self)
    self.delegateModel = [[MHReportRepairNewDelegateModel alloc] initWithDataArr:self.viewModel.dataSource tableView:self.tableView cellClassNames:@[NSStringFromClass(MHReportRepairNewCommonCell.class),NSStringFromClass(MHReportRepairNewEnableEditCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        @strongify(self)
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self.navigationController pushViewController:[MHReportRepairTypeViewController new] animated:YES];
        }else if (indexPath.section == 2 && indexPath.row == 0) {
            MHLoSetPlotController *loSetVc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:@"MHLoSetPlotController"];
            loSetVc.setType = MHLoSetPlotTypeReportRepairNew;
            loSetVc.repair_room_json = [MHReportRepairNewModel share].cache_room_json;
            loSetVc.repair_community_id = [MHReportRepairNewModel share].community_id;
            [self.navigationController pushViewController:loSetVc animated:YES];
        }
    }];

    [self.viewModel.refreshViewSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.reportNewCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [MHHUDManager dismiss];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kReportRepairPublishSuccessNotification" object:nil];
        [self.navigationController popToViewController:[self getListController] animated:YES];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
    [self resetBackNaviItem];
}

- (void)nav_back {
    [self.navigationController popToViewController:[self getListController] animated:YES];
}

- (UIViewController*)getListController {
    NSArray *controllers = self.navigationController.viewControllers;
    int index = 0;
    for (int i = 0; i<controllers.count; i ++) {
        UIViewController *controller = controllers[i];
        if ([controller isKindOfClass:[MHReportRepairMainViewController class]]) {
            index = i;
            break;
        }
    }
    return self.navigationController.viewControllers[index];
}

- (void)submitRepairInfo {
    [self.viewModel submitRepairInfo];
}

#pragma mark - Getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHReportRepairNewDelegateModel createTableWithStyle:UITableViewStyleGrouped
                                                       rigistNibCellNames:@[NSStringFromClass(MHReportRepairNewCommonCell.class),NSStringFromClass(MHReportRepairNewEnableEditCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (MHThemeButton *)bottomButton{
    if(!_bottomButton){
        _bottomButton = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:MScale * 19];
        [_bottomButton setTitle:@"发 布" forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 0;
        _bottomButton.layer.masksToBounds = NO;
    }
    return _bottomButton;
}


@end
