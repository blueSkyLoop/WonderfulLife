//
//  MHStoreShopDetailController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/26.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreShopDetailController.h"
#import "MHStoreGoodsDetailViewController.h"

#import "MHStoreShopDetailHeaderView.h"
#import "MHStoreRecomGoodsListCell.h"

#import "MHStoShopDetailModel.h"
#import "MHStoreDataHandler.h"
#import "MHStoreSearchModel.h"

#import "JFMapManager.h"
#import "JFAuthorizationStatusManager.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+NIM.h"
#import "MHMacros.h"
#import "UIImage+Color.h"
#import "MHHUDManager.h"
#import "YYModel.h"
#import "MHAlertView.h"

//#import "MJRefresh.h"

@interface MHStoreShopDetailController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MHStoreShopDetailHeaderViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@end

static NSString *MHStoreRecomGoodsListCellID = @"MHStoreRecomGoodsListCellID";
@implementation MHStoreShopDetailController{
    NSNumber *lat;
    NSNumber *lng;
}

#pragma mark - override

- (instancetype)initWithmerchant_id:(NSNumber *)merchant_id{
    if (self = [super init]) {
        self.merchant_id = merchant_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家详情";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    if ([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]) {
        [[JFMapManager manager] singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
            if (location) {
                lat = @(location.coordinate.latitude);
                lng = @(location.coordinate.longitude);
            }
            [self requestWithLngLat];
        }];
    }else{
        [self requestWithLngLat];
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(self.view.nim_width, 0.5)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHStoreRecomGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreRecomGoodsListCellID forIndexPath:indexPath];
    cell.searchModel = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MHStoreSearchGoodsModel *model = self.dataList[indexPath.row];
    MHStoreGoodsDetailViewController *vc = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:model.coupon_id.integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮点击
- (void)phoneCall{
    [[MHAlertView sharedInstance]
     showTitleActionSheetTitle:[NSString stringWithFormat:@"拨打%@电话",@"商家"] sureHandler:^{
         UIWebView *callWeb = [[UIWebView alloc]init];
         [self.view addSubview:callWeb];
         NSString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel://%@",_model.merchant_phone];
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]];
         [callWeb loadRequest:request];
     }
     cancelHandler:nil
     sureButtonColor:MColorBlue
     sureButtonTitle:_model.merchant_phone];
}

#pragma mark - private
- (void)loadData{
    
    [MHStoreDataHandler postMallMerchantGetMerchantID:_merchant_id Longitude:lng Latitude:lat CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            self.model = [MHStoShopDetailModel yy_modelWithJSON:data];
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)requestWithLngLat{
    [MHHUDManager show];
    [MHStoreDataHandler postMallMerchantCouponGetMerchantID:_merchant_id Longitude:lng Latitude:lat CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            self.dataList = [NSArray yy_modelArrayWithClass:[MHStoreSearchGoodsModel class] json:data];
            [self loadData];
            
        }else{
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }
    }];

}

- (void)setModel:(MHStoShopDetailModel *)model{
    _model = model;
    MHStoreShopDetailHeaderView *headerView = [MHStoreShopDetailHeaderView headerView];
    headerView.nim_width = self.view.nim_width;
    headerView.count = self.dataList.count;
    headerView.model = model;
    headerView.delegate = self;
    headerView.nim_height = headerView.subviews.lastObject.nim_bottom + ((model.mobile_phone.length&&!self.dataList.count) ? 29 : 10);
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 126;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreRecomGoodsListCell" bundle:nil] forCellReuseIdentifier:MHStoreRecomGoodsListCellID];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }
    }
    return _tableView;
}

@end






