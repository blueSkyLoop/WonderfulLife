//
//  MHStoreRecommandListController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/26.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRecommandListController.h"
#import "MHStoreShopDetailController.h"


#import "MHStoreShopSummaryCell.h"

#import "JFAuthorizationStatusManager.h"
#import "JFMapManager.h"
#import "MHStoreDataHandler.h"
#import "MHStoShopSummaryModel.h"
#import "MHStoShopDetailModel.h"

#import "YYModel.h"
#import "MHMacros.h"
#import "UIImage+Color.h"
#import "UIView+NIM.h"
#import "MJRefresh.h"
#import "MHHUDManager.h"
#import "MHUserInfoManager.h"
#import "MHRefreshGifHeader.h"

#import <CoreLocation/CoreLocation.h>

extern NSNumber *homeCommunity_id;

@interface MHStoreRecommandListController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,strong) NSNumber *lngNum;
@property (nonatomic,strong) NSNumber *latNum;
@property (nonatomic,strong) MJRefreshAutoNormalFooter * footerView;
@end

static NSString *MHStoreShopSummaryCellID = @"MHStoreShopSummaryCellID";
static NSString *MHStoreGoodsSummaryCellID = @"MHStoreGoodsSummaryCellID";

@implementation MHStoreRecommandListController{
    NSInteger page;
}


#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    self.dataList = [NSMutableArray array];

    [self tableView];
    
    [MHHUDManager show];
    if ([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]) {
        [[JFMapManager manager] singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
            if (location) {
                CGFloat lat = location.coordinate.latitude;
                CGFloat lng = location.coordinate.longitude;
                _lat = [NSString stringWithFormat:@"%f",lat];
                _lng = [NSString stringWithFormat:@"%f",lng];
                _latNum = @(lat);
                _lngNum = @(lng);
            }
            if (self.category_id) {
                [self loadDataWithLngLat];
            }else if (self.keyword){
                [self loadSearchData];
            }else{

                MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecommandDataWithLngLat)];
                mjheader.lastUpdatedTimeLabel.hidden = YES;
                mjheader.stateLabel.hidden = YES;
                self.tableView.mj_header = mjheader;
                [self.tableView.mj_header beginRefreshing];
            }
        }];
        
    }else{ // 无定位
        if (self.category_id) {
            [self loadDataWithLngLat];
        }else if (self.keyword){
            [self loadSearchData];
        }else{

            MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecommandDataWithLngLat)];
            mjheader.lastUpdatedTimeLabel.hidden = YES;
            mjheader.stateLabel.hidden = YES;
            self.tableView.mj_header = mjheader;
            [self.tableView.mj_header beginRefreshing];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(self.view.nim_width, 0.5)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHStoreShopSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreShopSummaryCellID forIndexPath:indexPath];
    if (_keyword) {
        MHStoShopDetailModel *summaryModel = self.dataList[indexPath.row];
        cell.shopModel = summaryModel;
    }else{
        MHStoShopSummaryModel *summaryModel = self.dataList[indexPath.row];
        cell.summaryModel = summaryModel;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MHStoreShopDetailController *vc = [MHStoreShopDetailController new];
    MHStoShopSummaryModel *summaryModel = self.dataList[indexPath.row];
    
    [MHHUDManager show];
    [MHStoreDataHandler postMallMerchantGetMerchantID:summaryModel.merchant_id Longitude:_lngNum Latitude:_latNum CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            vc.merchant_id = summaryModel.merchant_id;
            vc.model = [MHStoShopDetailModel yy_modelWithJSON:data];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

#pragma mark - 按钮点击

#pragma mark - private
- (void)loadRecommandDataWithLngLat{
    page = 1;
    [MHStoreDataHandler postMallMerchantRecommendListWithCommunityID:homeCommunity_id GPSLng:_lng GPSLat:_lat Page:@1 CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg){
        [MHHUDManager dismiss];
        [self.tableView.mj_header endRefreshing];
        if (success) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopSummaryModel class] json:data[@"merchant_list"][@"list"]]];
            [self.tableView reloadData];
            
            self.tableView.mj_footer = self.footerView ;
            
            if ([data[@"merchant_list"][@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadMoreRecommandDataWithLngLat{
    page ++;
    [MHStoreDataHandler postMallMerchantRecommendListWithCommunityID:homeCommunity_id GPSLng:_lng GPSLat:_lat Page:@(page) CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg){
        if (success) {
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopSummaryModel class] json:data[@"merchant_list"][@"list"]]];
            [self.tableView reloadData];
            
            if ([data[@"merchant_list"][@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }else{
            page --;
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadDataWithLngLat{
    [MHStoreDataHandler postMallMerchantByCategorylistWithCategoryID:self.category_id Page:@(1) Longitude:_lng Latitude:_lat CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopSummaryModel class] json:data[@"merchant_list"][@"list"]]];
            [self.tableView reloadData];
            
            MJRefreshAutoNormalFooter * footerView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [footerView setTitle:@"" forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer = footerView ;
            
            if ([data[@"merchant_list"][@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadMoreData{
    page ++;
    [MHStoreDataHandler postMallMerchantByCategorylistWithCategoryID:self.category_id Page:@(page) Longitude:_lng Latitude:_lat CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopSummaryModel class] json:data[@"merchant_list"][@"list"]]];
            [self.tableView reloadData];
            
            if ([data[@"merchant_list"][@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }else{
            page--;
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadSearchData{
    [MHStoreDataHandler postMallMerchantSearchWithCommunityID:homeCommunity_id Keyword:_keyword Longitude:_lngNum Latitude:_latNum Page:@1 CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopDetailModel class] json:data[@"list"]]];
            [self.tableView reloadData];
            
            MJRefreshAutoNormalFooter * footerView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSearchData)];
            [footerView setTitle:@"" forState:MJRefreshStateNoMoreData];
            self.tableView.mj_footer = footerView ;
            
            if ([data[@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadMoreSearchData{
    page++;
    [MHStoreDataHandler postMallMerchantSearchWithCommunityID:homeCommunity_id Keyword:_keyword Longitude:_lngNum Latitude:_latNum Page:@(page) CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            [self.dataList addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHStoShopDetailModel class] json:data[@"list"]]];
            [self.tableView reloadData];
            
            if ([data[@"has_next"] boolValue] == NO) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }else{
            page--;
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = MColorBackgroud;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 125;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreShopSummaryCell" bundle:nil] forCellReuseIdentifier:MHStoreShopSummaryCellID];
        
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (MJRefreshAutoNormalFooter *)footerView{
    if (_footerView == nil) {
        _footerView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecommandDataWithLngLat)];
        [_footerView setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    return _footerView;
}
@end






