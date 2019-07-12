//
//  MHVoSerIntegralDetailsController.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerIntegralDetailsController.h"
#import "MHVolSerComDetailController.h"

#import "MHVolunteerDataHandler.h"
#import "MHVoSerIntegralDetailsModel.h"

#import "MHVoSerIntegralDetailsCell.h"
#import "MHVolDateSectionHeaderView.h"
#import "MHVolNoDataSectionFooterView.h"
#import "MHVoSerIntegralDetailsHeaderView.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+MHDirectPop.h"
#import "UIViewController+HLNavigation.h"

#import "MHRefreshGifHeader.h"
#import "MHEmptyFooterView.h"
//#import "UIView+EmptyView.h"
#import "MHHUDManager.h"
#import "MHMacros.h"
#import "MJRefresh.h"
#import "NSDate+ChangeString.h"
@interface MHVoSerIntegralDetailsController ()<UITableViewDelegate,UITableViewDataSource,MHVoSerIntegralDetailsHeaderViewDelegate,MHNavigationControllerManagerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MHVoSerIntegralDetailsHeaderView  *headerView;

@property (nonatomic, assign) NSInteger dataType;
/**
 *  实体model
 */
@property (strong,nonatomic) MHVoSerIntegralDetailsModel *model;

/**全部*/
@property (strong,nonatomic) MHVoSerIntegralDetailsModel *allModel;

/**收入*/
@property (strong,nonatomic) MHVoSerIntegralDetailsModel *incomeModel;

/**支出*/
@property (strong,nonatomic) MHVoSerIntegralDetailsModel *costModel;
@end

@implementation MHVoSerIntegralDetailsController

// 梁斌文
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = MColorToRGB(0xF9FAFC);
    
    // headerView 赋值
    self.headerView = [MHVoSerIntegralDetailsHeaderView voSerIntegralDetailsHeaderView];
    
    self.headerView.delegate = self ;
    self.tableView.tableHeaderView = self.headerView;
    _dataType = -1;
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    MJRefreshAutoNormalFooter * mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(footerRequest)];
    [mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = mj_footer ;
    [self.tableView.mj_header beginRefreshing];
    //    [self request];
    
    //延迟一会，主要是避免机器速度太快，还没赋值完就已经执行完了viewDidLoad 这时候获取的值就是默认值而非传过来的值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.fromIndex == 1){
            [self resetBackNaviItem];
        }
    });
}

- (void)resetBackNaviItem{
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(nav_back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
//返回
- (void)nav_back{
    if(self.fromIndex == 1){
        //这会回到扫一扫页面
        [self.navigationController directTopControllerPop];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)bb_ShouldBack{
    if(self.fromIndex == 1){
        return NO;
    }
    return YES;
}

- (void)initUI{
    self.headerView.model = self.model;
    if (!self.model.details.count) {
        MHEmptyFooterView *footerView = [MHEmptyFooterView voSerEmptyViewImageName:@"vo_se_integral" title:@"暂无积分记录"];
        self.tableView.tableFooterView = footerView;
    }else{
        self.tableView.tableFooterView = nil ;
    }
    
    if ([self.model.query_finished isEqualToString:@"n"]) { // 尚未到达最后一条
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    switch (_dataType) {
        case -1:
        {
            self.allModel = self.model;
        }
            break;
        case 0:
        {
            self.incomeModel = self.model;
        }
            break;
        case 2:
        {
            self.costModel = self.model;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}


#pragma mark -  Request

- (void)request{
    [MHHUDManager show];
    [MHVolunteerDataHandler getVoSerIntegralDetails:_dataType dataDic:nil request:^(MHVoSerIntegralDetailsModel *data) {
        self.model = data ;
        [self initUI];
        [MHHUDManager dismiss];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footerRequest{
    MHVolunteerScorePerMonth *monthModel = [self.model.details lastObject];
    MHVolunteerScoreRecord *rec = [monthModel.records lastObject];
    NSString *year = [NSDate mh_YearWithString:rec.create_datetime];
    NSInteger month = [NSDate mh_MonthWithString:rec.create_datetime];
    month -- ;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:year forKey:@"year"];
    [dic setValue:[NSNumber numberWithInteger:month] forKey:@"month"];
    
    [MHHUDManager show];
    [MHVolunteerDataHandler getVoSerIntegralDetails:_dataType dataDic:dic request:^(MHVoSerIntegralDetailsModel *data) {
        self.model.query_finished = data.query_finished ;
        if (data.details.count) {
            // 在原有数据上直接添加数组
            [self.model.details addObjectsFromArray:data.details];
        }
        [self initUI];
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark tableViewDelegate & dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.details.count ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MHVolunteerScorePerMonth *scoreMonth = self.model.details[section];
    
    return scoreMonth.records.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVoSerIntegralDetailsCell * cell = [MHVoSerIntegralDetailsCell cellWithTableView:tableView];
    MHVolunteerScorePerMonth *month = self.model.details[indexPath.section];
    cell.model = month.records[indexPath.row];
    return cell ;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.model.details.count) {
        return 48 ;
    }
    return 0.01 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MHVolunteerScorePerMonth *scoreMonth = self.model.details[section];
    if (!scoreMonth.records.count) {
        return 70 ;
    }
    return 0.01 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    MHVolunteerScorePerMonth *monthModel = self.model.details[indexPath.section];
    MHVolunteerScoreRecord *rec = monthModel.records [indexPath.row];
    
    MHVolSerComDetailController *vc = [[MHVolSerComDetailController alloc] init];
    vc.type = MHVolSerComDetailTypeScoreRecord ;
    vc.detail_Id = rec.score_id ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.model.details.count) {
        MHVolunteerScorePerMonth *month = self.model.details[section];
        
        MHVolDateSectionHeaderView *header = [MHVolDateSectionHeaderView volDateHeaderViewWithTableView:tableView];
        header.leftTitleLB.text = month.month ;
        if (_dataType==-1) {
            header.rightTitleLB.text = [NSString stringWithFormat:@"新增：%@\t兑换：%@",[month.income stringValue],[month.cost stringValue]];
        }else if (_dataType==0){
            header.rightTitleLB.text = [NSString stringWithFormat:@"新增：%@",[month.income stringValue]];
        }else{
            header.rightTitleLB.text = [NSString stringWithFormat:@"兑换：%@",[month.cost stringValue]];
        }
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MHVolunteerScorePerMonth *scoreMonth = self.model.details[section];
    if (!scoreMonth.records.count) {
        MHVolNoDataSectionFooterView *footer = [MHVolNoDataSectionFooterView volNoDataFooterViewWithTableView:tableView];
        footer.noDataLB.text = @"暂无积分记录";
        return footer ;
    }
    return nil;
}

#pragma mark - headerViewDelegate
- (void)didSelectHeaderViewBtn:(UIButton *)sender{
    
    MHVoSerIntegralDetailsModel * transitModel;
    switch (sender.tag) {
        case 0:
        {
            transitModel = self.allModel;
            _dataType = sender.tag - 1 ;
        }
            break;
        case 1:
        {
            transitModel = self.incomeModel;
            _dataType = sender.tag - 1 ;
        }
            break;
        case 2:
        {
            transitModel = self.costModel;
            _dataType = sender.tag  ;
        }
            break;
        default:
            break;
    }
    self.model = transitModel;
    if (!transitModel) {
        [self request];
    }else{
        [self initUI];
    }
}



@end
