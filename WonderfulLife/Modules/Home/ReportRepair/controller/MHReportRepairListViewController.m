//
//  MHReportRepairListViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListViewController.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "LCommonModel.h"
#import "MHConst.h"

#import "MHReportRepairListCell.h"


#import "MHReportRepairListDelegateModel.h"
#import "MHReportRepairListViewModel.h"

#import "MHReportRepairDetailViewController.h"

//弹窗
#import "MHReportRepairEvaluateView.h"
#import "MHReportRepairProblemUnsolvedView.h"
#import "MHReportRepairCancelView.h"
#import "MHRefreshGifHeader.h"

@interface MHReportRepairListViewController ()

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)MHReportRepairListDelegateModel *delegateModel;
@property (nonatomic,strong)MHReportRepairListViewModel *viewModel;

@property (nonatomic,strong)UIView *emptyView;

@property (nonatomic,assign)BOOL refreshFlag;


@end

@implementation MHReportRepairListViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self bindViewModel];
    
    [self notificationHandler];
}

- (void)setType:(ReportRepairType)type{
    if(_type != type){
        _type = type;
        self.viewModel.type = _type;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.viewModel.dataArr.count == 0 || self.refreshFlag){
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNaviBottomLineColor:[UIColor whiteColor]];
}

//通知处理
- (void)notificationHandler{
    //要刷新列表的通知
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReloadReportRepairListNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if(self.view.window){
                self.refreshFlag = NO;
                [self.tableView.mj_header beginRefreshing];
            }else{
                //记录一下，待出现这个界面时刷新数据
                self.refreshFlag = YES;
            }
        });
        
    }];
    
}


- (void)setUpUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.reportListCommand execute:@(NO)];
    }];
}

- (void)loadNewData {
    [self.viewModel.reportListCommand execute:@(YES)];
}

- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.UIRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
        [self clearEmptyView];
        if(self.viewModel.dataArr.count == 0){
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }];
    
    //列表
    [self.viewModel.reportListCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *has_Next) {
        @strongify(self);
        self.refreshFlag = NO;
        [self.tableView.mj_header endRefreshing];
        if([has_Next boolValue]){
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [[self.viewModel.reportListCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MHHUDManager showWithError:error withView:self.view];
    }];
    //取消
    [self.viewModel.reportListCancelCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.viewModel.reportListCancelCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    //仍未解决
    [self.viewModel.reportListSolveCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.viewModel.reportListSolveCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    //评价
    [self.viewModel.reportListEvaluateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.viewModel.reportListEvaluateCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    
    self.delegateModel = [[MHReportRepairListDelegateModel alloc] initWithDataArr:self.viewModel.dataArr tableView:self.tableView cellClassNames:@[NSStringFromClass(MHReportRepairListCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, MHReportRepairListModel *cellModel) {
        @strongify(self);
        //详情
        MHReportRepairDetailViewController *vc = [[MHReportRepairDetailViewController alloc] initWithRepairment_id:cellModel.repairment_id];
        [self.navigationController pushViewController:vc animated:YES];
       
    }];
    //index  1 取消   2 去评价  3 仍未解决
    self.delegateModel.reportRepairCellClikBlock = ^(UIButton *btn,NSInteger index,MHReportRepairListModel *model){
        @strongify(self);
        [self jumpToPageWithIndex:index model:model];
    };
    
}

- (void)clearEmptyView{
    if(_emptyView){
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
}

- (void)jumpToPageWithIndex:(NSInteger)index model:(MHReportRepairListModel *)model{
    switch (index) {
        case 1://取消
        {
            MHReportRepairCancelView *cancelView = [MHReportRepairCancelView loadViewFromXib];
            [self.view.window addSubview:cancelView];
            [cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            cancelView.cacelSureBlock = ^{
                @strongify(self);
                [self.viewModel.reportListCancelCommand execute:@(model.repairment_id)];
            };
            
        }
            break;
        case 2://去评价
        {
            MHReportRepairEvaluateView *evaluateView = [MHReportRepairEvaluateView loadViewFromXib];
            [self.view.window addSubview:evaluateView];
            [evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            evaluateView.evaluateBlock = ^(NSString *evaluatStr, CGFloat score){
                @strongify(self);
                [self.viewModel.reportListEvaluateCommand execute:@{@"evaluate_cont":evaluatStr,@"evaluate_level":@(score),@"repairment_id":@(model.repairment_id)}];
            };
        }
            break;
        case 3://仍未解决
        {
            MHReportRepairProblemUnsolvedView *solveView = [MHReportRepairProblemUnsolvedView loadViewFromXib];
            [self.view.window addSubview:solveView];
            [solveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            solveView.solvedBlock = ^(NSString *reasonStr){
                @strongify(self);
                [self.viewModel.reportListSolveCommand execute:@{@"remark":reasonStr,@"repairment_id":@(model.repairment_id)}];
            };
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHReportRepairListDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(MHReportRepairListCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = MColorBackgroud;
    }
    return _tableView;
}

- (MHReportRepairListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHReportRepairListViewModel new];
    }
    return _viewModel;
}

#pragma mark - 空状态下的视图
- (UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [UIView new];
        _emptyView.backgroundColor = MColorToRGB(0XF9FAFC);
        UIView *bgView = [UIView new];
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"announcement_notice_empty"];
        UILabel *label = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MColorToRGB(0X99A9BF)];
        label.text = @"暂无内容";
        [bgView addSubview:imageView];
        [bgView addSubview:label];
        [_emptyView addSubview:bgView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(8);
            make.left.greaterThanOrEqualTo(bgView.mas_left);
            make.right.lessThanOrEqualTo(bgView.mas_right);
            make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
