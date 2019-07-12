//
//  MHReportRepairDetailViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailViewController.h"

#import "MHConst.h"

#import "MHReportRepairDetailProgressCell.h"
#import "MHReportRepairDetailCell.h"

#import "MHReportRepairDetailDelegateModel.h"
#import "MHReportRepairDetailViewModel.h"
#import "MHReportRepairListViewModel.h"

#import "MHReportRepairPhotoPreViewController.h"

//弹窗
#import "MHReportRepairEvaluateView.h"
#import "MHReportRepairProblemUnsolvedView.h"
#import "MHReportRepairCancelView.h"
#import "MHReportRepairHaveEvaluateView.h"


@interface MHReportRepairDetailViewController ()

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)MHReportRepairDetailDelegateModel *delegateModel;
@property (nonatomic,strong)MHReportRepairDetailViewModel *viewModel;
//复用列表的viewModel
@property (nonatomic,strong)MHReportRepairListViewModel *listViewModel;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *button;

@end

@implementation MHReportRepairDetailViewController

- (id)initWithRepairment_id:(NSInteger)repairment_id{
    self = [super init];
    if(self){
        self.repairment_id = repairment_id;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
}

- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@0);
    }];
}

- (void)bindViewModel{
    
    self.viewModel.repairment_id = self.repairment_id;
    
    @weakify(self);
    [self.viewModel.reportDetailCommand.executionSignals.switchToLatest subscribeNext:^(MHReportRepairDetailModel  *model) {
        @strongify(self);
        //更新底部按钮和UI
        [self updateBottomView];
        self.delegateModel.model = model;
        [self.tableView reloadData];
        if(model.repair_type == 0){
            self.title = @"报修详情";
        }else if(model.repair_type == 1){
            self.title = @"投诉详情";
        }
    }];
    [[self.viewModel.reportDetailCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    
    //取消（处理中的才可以取消）
    [self.listViewModel.reportListCancelCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //取消成功之后按钮设置为不可按，以防再次获取详情时出错，导致再次按下
        self.button.enabled = NO;
        [self.viewModel.reportDetailCommand execute:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.listViewModel.reportListCancelCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    //仍未解决
    [self.listViewModel.reportListSolveCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.reportDetailCommand execute:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.listViewModel.reportListSolveCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    //评价
    [self.listViewModel.reportListEvaluateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.reportDetailCommand execute:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadReportRepairListNotification object:nil];
    }];
    [[self.listViewModel.reportListEvaluateCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    
    self.delegateModel = [[MHReportRepairDetailDelegateModel alloc] initWithDataArr:self.viewModel.dataArr tableView:self.tableView cellClassNames:@[NSStringFromClass(MHReportRepairDetailProgressCell.class),NSStringFromClass(MHReportRepairDetailCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        
    }];
    
    //去评价
    self.delegateModel.evaluateBlock = ^{
        @strongify(self);
        [self evaluateHandler];
    };
    
    self.delegateModel.pictreCollectionViewDidSelectBlock = ^(NSIndexPath *indexPath,MHReportRepairPictureModel *cellModel){
        @strongify(self);
        //图片预览,查看大图
        MHReportRepairPhotoPreViewController *vc = [MHReportRepairPhotoPreViewController new];
        vc.clickNum = indexPath.row;
        vc.dataArr = [self.viewModel allPhotos];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    [self.viewModel.reportDetailCommand execute:nil];
    
}

#pragma mark - 点击评价事件的处理
- (void)evaluateHandler{
    //已评价
    if(self.viewModel.model.is_evaluate){
        
        MHReportRepairHaveEvaluateView *evaluateView = [MHReportRepairHaveEvaluateView loadViewFromXib];
        evaluateView.score = self.viewModel.model.evaluate_level;
        evaluateView.evaluateLabel.text = self.viewModel.model.evaluate_cont;
        [self.view.window addSubview:evaluateView];
        [evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view.window);
        }];
        
    }else{//去评价
        MHReportRepairEvaluateView *evaluateView = [MHReportRepairEvaluateView loadViewFromXib];
        [self.view.window addSubview:evaluateView];
        [evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view.window);
        }];
        @weakify(self);
        evaluateView.evaluateBlock = ^(NSString *evaluatStr, CGFloat score){
            @strongify(self);
            [self.listViewModel.reportListEvaluateCommand execute:@{@"evaluate_cont":evaluatStr,@"evaluate_level":@(score),@"repairment_id":@(self.viewModel.repairment_id)}];
        };
    }
}

#pragma mark - 更新底部按钮
- (void)updateBottomView{
    //报修单状态.0：待处理，1：处理中，2：已完成，3：已取消 4：已激活
    switch (self.viewModel.model.status) {
        case 0:
        case 1:
        {
            [_button setTitle:@"取 消" forState:UIControlStateNormal];
            [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
            }];
            [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.equalTo(@60);
            }];
        }
            break;
        case 2:
        {
            if(self.viewModel.model.is_evaluate){
                [_button setTitle:@" " forState:UIControlStateNormal];
                [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.height.equalTo(@0);
                }];
            }else{
                [_button setTitle:@"仍未解决" forState:UIControlStateNormal];
                [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
                }];
                [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.height.equalTo(@60);
                }];
            }
        }
            break;
        case 3:
        {
            [_button setTitle:@" " forState:UIControlStateNormal];
            [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.equalTo(@0);
            }];
        }
            break;
        case 4:
        {
            [_button setTitle:@"取 消" forState:UIControlStateNormal];
            [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
            }];
            [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.height.equalTo(@60);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 底部按钮事件
- (void)hadleBottomButtonAction{
    //报修单状态.0：待处理，1：处理中，2：已完成，3：已取消 4:已激活
    switch (self.viewModel.model.status) {
        case 0:
        case 1:
        {
            //取消
            MHReportRepairCancelView *cancelView = [MHReportRepairCancelView loadViewFromXib];
            [self.view.window addSubview:cancelView];
            [cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            cancelView.cacelSureBlock = ^{
                @strongify(self);
                [self.listViewModel.reportListCancelCommand execute:@(self.viewModel.model.repairment_id)];
            };
            
        }
            break;
        case 2:
        {
            //未评价的时候可以有仍未解决按钮
            if(self.viewModel.model.is_evaluate == 0){
                MHReportRepairProblemUnsolvedView *solveView = [MHReportRepairProblemUnsolvedView loadViewFromXib];
                [self.view.window addSubview:solveView];
                [solveView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view.window);
                }];
                @weakify(self);
                solveView.solvedBlock = ^(NSString *reasonStr){
                    @strongify(self);
                    [self.listViewModel.reportListSolveCommand execute:@{@"remark":reasonStr,@"repairment_id":@(self.viewModel.repairment_id)}];
                };
            }
        }
            break;
        case 3:
        {
            //已取消，不显示底部按钮
        }
            break;
        case 4:
        {
            //取消
            MHReportRepairCancelView *cancelView = [MHReportRepairCancelView loadViewFromXib];
            [self.view.window addSubview:cancelView];
            [cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view.window);
            }];
            @weakify(self);
            cancelView.cacelSureBlock = ^{
                @strongify(self);
                [self.listViewModel.reportListCancelCommand execute:@(self.viewModel.model.repairment_id)];
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
        _tableView = [MHReportRepairDetailDelegateModel createTableWithStyle:UITableViewStyleGrouped rigistNibCellNames:@[NSStringFromClass(MHReportRepairDetailProgressCell.class),NSStringFromClass(MHReportRepairDetailCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = MColorBackgroud;
    }
    return _tableView;
}
- (MHReportRepairDetailViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHReportRepairDetailViewModel new];
    }
    return _viewModel;
}
- (MHReportRepairListViewModel *)listViewModel{
    if(!_listViewModel){
        _listViewModel = [MHReportRepairListViewModel new];
    }
    return _listViewModel;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [UIView new];
        _bottomView.clipsToBounds = YES;
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = MRGBColor(211, 220, 230);
        [_bottomView addSubview:topLine];
        [_bottomView addSubview:self.button];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_bottomView);
            make.height.equalTo(@.5);
        }];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bottomView);
        }];
    }
    return _bottomView;
}
- (UIButton *)button{
    if(!_button){
        _button = [UIButton new];
        [_button setTitleColor:MRGBColor(71, 86, 105) forState:UIControlStateNormal];
        [_button setTitleColor:MRGBColor(192, 204, 218) forState:UIControlStateDisabled];
        _button.titleLabel.font = [UIFont systemFontOfSize:MScale * 19];
        [_button setTitle:@"仍未解决" forState:UIControlStateNormal];
        @weakify(self);
        [[[_button rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            //底部按钮事件,自行根据状态判断
            [self hadleBottomButtonAction];
        }];
    }
    return _button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
