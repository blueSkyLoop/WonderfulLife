//
//  MHStoreRecommedGoodsListViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRecommedGoodsListViewController.h"

#import "MJRefresh.h"
#import "JFAuthorizationStatusManager.h"
#import "JFMapManager.h"
#import "LCommonModel.h"
#import "MHConst.h"

#import "MHStoreRecommGoodsListDelegateModel.h"
#import "MHStoreRecomGoodsListViewModel.h"
#import "MHStoreRecomGoodsListCell.h"
#import "MHStoreGoodsHandler.h"

#import "MHStoreGoodsDetailViewController.h"
#import "MHStoreRefundViewController.h"
#import "MHRefreshGifHeader.h"

@interface MHStoreRecommedGoodsListViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MHStoreRecomGoodsListViewModel *viewModel;
@property (nonatomic,strong)MHStoreRecommGoodsListDelegateModel *delegateModel;
@property (nonatomic,strong)UIView *emptyView;

//是否需要等待定位完成之后调接口
@property (nonatomic,assign)BOOL needWaitForLocation;
@property (nonatomic,assign)BOOL refreshFlag;

@property (nonatomic,assign)MHStoreGoodsListType type;

@end

@implementation MHStoreRecommedGoodsListViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}


- (id)initWithcommunity_id:(NSInteger)community_id keyword:(NSString *)keyWord type:(MHStoreGoodsListType)type{
    self = [super init];
    if(self){
        self.type = type;
        self.viewModel.community_id = community_id;
        self.viewModel.keyWord = keyWord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //title 由外部设置
    if(!self.title){
        self.title = @"推荐商品";
    }
    
    self.needWaitForLocation = YES;
    
    [self verifyLocationEnable];
    
    [self notificationHandler];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delayExecute];
    });
    
}



//延迟后（定位超时）判断
- (void)delayExecute{
    //超时都没有定位成功，也要请求数据了
    if(self.needWaitForLocation){
        [MHHUDManager dismiss];
        self.needWaitForLocation = NO;
        if(self.viewModel.dataSoure.count == 0){
            
            [self.tableView.mj_header beginRefreshing];
            
        }
    }
    
}

- (void)verifyLocationEnable{
    if(![JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]){
        self.needWaitForLocation = NO;
        //提示一次即可，不然每次进来都提示也不友好
        if(![MHStoreGoodsHandler shareManager].locationUnabelSuggestFlag){
            [MHStoreGoodsHandler shareManager].locationUnabelSuggestFlag = YES;
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeMap target:self];
        }
        //没有定位要置为0
        [MHStoreGoodsHandler shareManager].current_gps_lat = 0;
        [MHStoreGoodsHandler shareManager].current_gps_lng = 0;
        
    }else{
        [MHStoreGoodsHandler shareManager].locationUnabelSuggestFlag = YES;
    }
    if([MHStoreGoodsHandler shareManager].current_gps_lat && [MHStoreGoodsHandler shareManager].current_gps_lng){
        [self.viewModel updateLocation];
        self.needWaitForLocation = NO;
    }
}

//定位
- (void)startLocation{
    if([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]){
        @weakify(self);
        if(self.needWaitForLocation){
            [MHHUDManager showWithInfor:@"正在定位..."];
        }
        [[JFMapManager manager] singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
            @strongify(self);
            if(location){
                if(self.needWaitForLocation){
                    [MHHUDManager dismiss];
                }
                [MHStoreGoodsHandler shareManager].current_gps_lat = location.coordinate.latitude;
                [MHStoreGoodsHandler shareManager].current_gps_lng = location.coordinate.longitude;
                
                if(self.needWaitForLocation && !self.viewModel.listRequesting && self.viewModel.dataSoure.count == 0){
                    self.viewModel.current_gps_lat = location.coordinate.latitude;
                    self.viewModel.current_gps_lng = location.coordinate.longitude;
                    [self.tableView.mj_header beginRefreshing];
                }
                
                self.needWaitForLocation = NO;
                
            }
        }];
    }
}

//通知处理
- (void)notificationHandler{
    //要刷新列表的通知
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kStoreOrderPaySuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if(self.view.window){
                self.refreshFlag = NO;
                NSInteger coupon_id = [x.object integerValue];
                if(coupon_id == 0) return ;
                BOOL isExist = [self.viewModel isExsitObjectWithCoupon_id:coupon_id];
                if(isExist){
                    [self.tableView.mj_header beginRefreshing];
                }
            }else{
                //记录一下，待出现这个界面时刷新数据
                NSInteger coupon_id = [x.object integerValue];
                if(coupon_id == 0) return ;
                BOOL isExist = [self.viewModel isExsitObjectWithCoupon_id:coupon_id];
                if(isExist){
                    self.refreshFlag = YES;
                }
            }
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startLocation];
    [self setNaviBottomLineDefaultColor];
    if(self.refreshFlag){
        
        if(!self.needWaitForLocation && !self.viewModel.listRequesting){
            [self.tableView.mj_header beginRefreshing];
        }
        
    }else{
        
        if(!self.needWaitForLocation && !self.viewModel.listRequesting && self.viewModel.dataSoure.count == 0){
            [self.tableView.mj_header beginRefreshing];
        }
        
    }
    
}

- (void)mh_setUpUI{
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
        if(self.type == MHStoreGoodsList_search){
            [self.viewModel.searchGoodListCommand execute:@(NO)];
        }else if(self.type == MHStoreGoodsList_recommed){
            [self.viewModel.goodsListCommand execute:@(NO)];
        }
        
    }];
    
}

- (void)loadNewData {
    if(self.type == MHStoreGoodsList_search){
        [self.viewModel.searchGoodListCommand execute:@(YES)];
    }else if(self.type == MHStoreGoodsList_recommed){
        [self.viewModel.goodsListCommand execute:@(YES)];
    }
}

- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.UIRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.refreshFlag = NO;
        self.needWaitForLocation = NO;
        [self.tableView reloadData];
        [self clearEmptyView];
        if(self.viewModel.dataSoure.count == 0){
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }];
   
    [self.viewModel.searchGoodListCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *has_Next) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if([has_Next boolValue]){
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [[self.viewModel.searchGoodListCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [MHHUDManager showWithError:error withView:self.view];
        
    }];
    

    [self.viewModel.goodsListCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *has_Next) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if([has_Next boolValue]){
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [[self.viewModel.goodsListCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [MHHUDManager showWithError:error withView:self.view];
        
    }];
    
    self.delegateModel = [[MHStoreRecommGoodsListDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure tableView:self.tableView cellClassNames:@[NSStringFromClass(MHStoreRecomGoodsListCell.class)] useAutomaticDimension:NO cellDidSelectedBlock:^(NSIndexPath *indexPath, MHStoreRecomGoodsListModel *cellModel) {
        @strongify(self);
        //商品详情
        MHStoreGoodsDetailViewController *detailVC = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:cellModel.coupon_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
}

- (void)clearEmptyView{
    if(_emptyView){
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
}


#pragma mark - lazyload

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHStoreRecommGoodsListDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(MHStoreRecomGoodsListCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (MHStoreRecomGoodsListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreRecomGoodsListViewModel new];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
