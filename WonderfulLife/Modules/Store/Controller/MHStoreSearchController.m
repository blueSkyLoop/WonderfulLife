//
//  MHStoreSearchController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreSearchController.h"
#import "MHStoreRecommandListController.h"
#import "MHStoreRecommedGoodsListViewController.h"
#import "MHStoreGoodsDetailViewController.h"
#import "MHStoreShopDetailController.h"
#import "MHStoreController.h"

#import "MHStoreShopSummaryCell.h"
#import "MHStoreRecomGoodsListCell.h"
#import "MHStoreHomeSectionHeaderView.h"
#import "MHStoSearchFooterView.h"

#import "JFAuthorizationStatusManager.h"
#import "JFMapManager.h"
#import "MHStoreDataHandler.h"
#import "MHStoreSearchModel.h"
#import "MHStoShopDetailModel.h"

#import "MHUserInfoManager.h"
#import "MHHUDManager.h"
#import "YYModel.h"
#import "UIView+NIM.h"
#import "MHMacros.h"

extern NSNumber *homeCommunity_id;

@interface MHStoreSearchController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MHStoreHomeSectionHeaderViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MHStoreSearchModel *model;
@property (nonatomic,strong) NSNumber *lat;
@property (nonatomic,strong) NSNumber *lng;
@property (nonatomic,strong) UIView *footerView;
@end

static NSString *MHStoreShopSummaryCellID = @"MHStoreShopSummaryCellID";
static NSString *MHStoreRecomGoodsListCellID = @"MHStoreRecomGoodsListCellID";
static NSString *MHStoreHomeSectionHeaderViewID = @"MHStoreHomeSectionHeaderViewID";
static NSString *MHStoSearchFooterViewID = @"MHStoSearchFooterViewID";

@implementation MHStoreSearchController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 2;
    if (_model.coupon_list_vos.count == 0) {
        count --;
    }
    if (_model.merchant_list_vos.count == 0) {
        count --;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.coupon_list_vos.count == 0 && _model.merchant_list_vos.count) {
        return _model.merchant_list_vos.count;
    }else if (_model.coupon_list_vos.count && _model.merchant_list_vos.count == 0){
        return _model.coupon_list_vos.count;
    }else{
        if (section == 0) {
            return _model.merchant_list_vos.count;
        }else{
            return _model.coupon_list_vos.count;
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_model.coupon_list_vos.count == 0 && _model.merchant_list_vos.count) {
        return [self configureShopCellWithTableView:tableView IndexPath:indexPath];
    }else if (_model.coupon_list_vos.count && _model.merchant_list_vos.count == 0){
        return [self configureGoodsCellWithTableView:tableView IndexPath:indexPath];
    }else{
        if (indexPath.section == 0) {
            return [self configureShopCellWithTableView:tableView IndexPath:indexPath];
        }else{
            return [self configureGoodsCellWithTableView:tableView IndexPath:indexPath];
            
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHStoreHomeSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHStoreHomeSectionHeaderViewID];
    if (_model.merchant_list_vos.count == 0 && _model.coupon_list_vos.count){//无推荐商家，有推荐商品
        if (section == 0) {
            [self setupGoodsHeader:header];
        }
    }else if (_model.merchant_list_vos.count  && _model.coupon_list_vos.count == 0){//有推荐商家，无推荐商品
        if (section == 0) {
            [self setupshopHeader:header];
        }
    }else if (_model.merchant_list_vos.count && _model.coupon_list_vos.count){//有推荐商家，有推荐商品
        if (section == 0) {
            [self setupshopHeader:header];
        }else if (section == 1){
            [self setupGoodsHeader:header];
        }
    }
    header.tag = section;
    header.delegate = self;
    return header;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    MHStoSearchFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHStoSearchFooterViewID];
//    return footer;
//}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 49;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        if (_model.merchant_list_vos.count) { //第一组商家列表
//            if ( _model.has_next_merchant) { //有更多
//                return 0;
//            }else{
//                return 44;
//            }
//        }else if (_model.coupon_list_vos.count){ //第一组商品列表
//            if (_model.has_next_coupon) {
//                return 0;
//            }else{
//                return 44;
//            }
//        }else{
//            return 0;
//        }
//    }else{
//        if (_model.has_next_coupon) {
//            return 0;
//        }else{
//            return 44;
//        }
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_model.merchant_list_vos.count == 0 && _model.coupon_list_vos.count){//无推荐商家，有推荐商品
        if (indexPath.section == 0) {
            [self pushGoodsDetailControllerWithIndex:indexPath.row];
        }
    }else if (_model.merchant_list_vos.count  && _model.coupon_list_vos.count == 0){//有推荐商家，无推荐商品
        if (indexPath.section == 0) {
            [self pushShopDetailControllerWithIndex:indexPath.row];
        }
    }else if (_model.merchant_list_vos.count && _model.coupon_list_vos.count){//有推荐商家，有推荐商品
        if (indexPath.section == 0) {
            [self pushShopDetailControllerWithIndex:indexPath.row];
        }else if (indexPath.section == 1){
            [self pushGoodsDetailControllerWithIndex:indexPath.row];
        }
    }
}

- (void)checkMoreRecommandWithTag:(NSInteger)tag{
    
    if (_model.merchant_list_vos.count == 0 && _model.coupon_list_vos.count){//无推荐商家，有推荐商品
        if (tag == 0) {
            [self pushRecommandGoodsController];
        }
    }else if (_model.merchant_list_vos.count  && _model.coupon_list_vos.count == 0){//有推荐商家，无推荐商品
        if (tag == 0) {
            [self pushRecommandShopController];
        }
    }else if (_model.merchant_list_vos.count && _model.coupon_list_vos.count){//有推荐商家，有推荐商品
        if (tag == 0) {
            [self pushRecommandShopController];
        }else if (tag == 1){
            [self pushRecommandGoodsController];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchVC.searchBar endEditing:YES];
}

#pragma mark - searchResult
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (searchController.searchBar.text.length == 0) {
        return;
    }
    

    if ([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]) {
        if (_lat) {
            [self requestWithLngLat];
        }else{
            [[JFMapManager manager] singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
                if (location) {
                    _lat = @(location.coordinate.latitude);
                    _lng = @(location.coordinate.longitude);
                }
                [self requestWithLngLat];
            }];
        }
    }else{
        _lat = nil;
        _lng = nil;
        [self requestWithLngLat];
    }
    
    
}

#pragma mark - 按钮点击

#pragma mark - private
- (void)requestWithLngLat{
    [MHHUDManager show];
    [MHStoreDataHandler postMallSearchWithKeyword:_searchVC.searchBar.text CommunityID:homeCommunity_id Longitude:_lng Latitude:_lat CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            _model = [MHStoreSearchModel yy_modelWithJSON:data];
            if (_model.coupon_list_vos.count==0 && _model.merchant_list_vos.count==0) {
                self.tableView.scrollEnabled = NO;
                self.tableView.tableFooterView = self.footerView;
            }else{
                self.tableView.scrollEnabled = YES;
                self.tableView.tableFooterView = nil;
            }
            
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)setupshopHeader:(MHStoreHomeSectionHeaderView *)header{
    header.recommandLabel.text = @"商家列表";
    header.hideMore = !_model.has_next_merchant;
}

- (void)setupGoodsHeader:(MHStoreHomeSectionHeaderView *)header{
    header.recommandLabel.text = @"商品列表";
    header.hideMore = !_model.has_next_coupon;
}

- (UITableViewCell *)configureShopCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    MHStoreShopSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreShopSummaryCellID forIndexPath:indexPath];
    cell.shopModel = _model.merchant_list_vos[indexPath.row];
    return cell;
}

- (UITableViewCell *)configureGoodsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    MHStoreRecomGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreRecomGoodsListCellID forIndexPath:indexPath];
    MHStoreSearchGoodsModel *goodsModel = _model.coupon_list_vos[indexPath.row];
    cell.searchModel = goodsModel;
    return cell;
}

- (void)pushRecommandShopController{
    MHStoreRecommandListController *vc = [[MHStoreRecommandListController alloc] init];
    vc.title = @"商家列表";
    vc.keyword = _searchVC.searchBar.text;
    [_storeVC.navigationController pushViewController:vc animated:YES];
}

- (void)pushRecommandGoodsController{
    MHStoreRecommedGoodsListViewController *recommendVC = [[MHStoreRecommedGoodsListViewController alloc] initWithcommunity_id:homeCommunity_id.integerValue keyword:_searchVC.searchBar.text type:MHStoreGoodsList_search];
    recommendVC.title = @"商品列表";
    [_storeVC.navigationController pushViewController:recommendVC animated:YES];
}

- (void)pushGoodsDetailControllerWithIndex:(NSInteger)index{
    MHStoreGoodsDetailViewController *vc = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:[_model.coupon_list_vos[index] coupon_id].integerValue];
    [_storeVC.navigationController pushViewController:vc animated:YES];
}

- (void)pushShopDetailControllerWithIndex:(NSInteger)index{
    MHStoreShopDetailController *vc = [MHStoreShopDetailController new];
    MHStoShopDetailModel *model  = _model.merchant_list_vos[index];
    NSNumber *merchant_id = model.merchant_id;
    vc.merchant_id = merchant_id;
    [_storeVC.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 126;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreRecomGoodsListCell" bundle:nil] forCellReuseIdentifier:MHStoreRecomGoodsListCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreShopSummaryCell" bundle:nil] forCellReuseIdentifier:MHStoreShopSummaryCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreHomeSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:MHStoreHomeSectionHeaderViewID];
//        [_tableView registerClass:[MHStoSearchFooterView class] forHeaderFooterViewReuseIdentifier:MHStoSearchFooterViewID];

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.view.nim_height)];
        _footerView.backgroundColor = MColorBackgroud;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StoreEmpty"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.nim_size = CGSizeMake(120, 120);
        imageView.nim_centerX = self.view.nim_width/2;
        imageView.nim_top = 40;
        [_footerView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"搜索不到任何结果";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = MColorFootnote2;
        [label sizeToFit];
        label.nim_centerX = self.view.nim_width/2;
        label.nim_top = imageView.nim_bottom+8;
        [_footerView addSubview:label];
        
    }
    return _footerView;
}
@end






