//
//  MHStoreController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/23.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreController.h"
#import "MHStoreSearchController.h"
#import "MHStoreRecommandListController.h"
#import "MHStoreShopDetailController.h"
#import "MHGcTableController.h"
#import "MHNavigationControllerManager.h"
#import "MHStoreGoodsDetailViewController.h"
#import "MHMerchantOrderController.h"
#import "MHMineMerchantController.h"

#import "UIViewController+ShowCustomAlterView.h"
#import "MHStoreRecomGoodsListCell.h"
#import "MHStoreHomeHeaderView.h"
#import "MHStoreHomeSectionHeaderView.h"
#import "MHStHoRecommandGoodsCell.h"
#import "MHStHoRecommandShopCell.h"
#import "MHStHoRecommandShopView.h"
#import "MHStHoRecommandGoodsView.h"
#import "MHBuildingView.h"
#import "MHRefreshGifHeader.h"

#import "MHStoreDataHandler.h"
#import "MHStoreHomeModel.h"
#import "MHStoShopDetailModel.h"
#import "MHUserInfoManager.h"

#import "UIView+NIM.h"
#import "MHMacros.h"
#import "UIImage+Color.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "HLWebViewController.h"
#import "JFAuthorizationStatusManager.h"
#import "JFMapManager.h"
#import "MHUserInfoManager.h"
#import "MHAreaManager.h"
#import "MHConst.h"

#import "MHQRCodeController.h"
#import "MHStoreRecommedGoodsListViewController.h"
#import "UIViewController+PresentLoginController.h"

extern NSNumber *homeCommunity_id;

@interface MHStoreController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,MHStoreHomeHeaderViewDelegate,MHStoreHomeSectionHeaderViewDelegate,MHStHoRecommandShopViewDelegate,MHStHoRecommandGoodsViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MHStoreHomeHeaderView *headerView;
@property (nonatomic,strong) UIView *beginView;
@property (nonatomic,strong) UIImage *shadowImage;
@property (nonatomic,strong) MJRefreshAutoFooter *mj_footer;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic, strong) UISearchController *searchVC;
@property (nonatomic,strong) MHStoreSearchController *resultVC;
@property (nonatomic,strong) MHStoreHomeModel *model;

@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,strong) NSNumber *lngNum;
@property (nonatomic,strong) NSNumber *latNum;
@end

static NSString *MHStoreHomeRecommandCellID =  @"MHStoreHomeRecommandCellID";
static NSString *MHStHoRecommandGoodsCellID = @"MHStHoRecommandGoodsCellID";
static NSString *MHStoreRecomGoodsListCellID = @"MHStoreRecomGoodsListCellID";
static NSString *MHStoreHomeSectionHeaderViewID = @"MHStoreHomeSectionHeaderViewID";
static NSString *MHStoreHomeSectionFooterViewID = @"MHStoreHomeSectionFooterViewID";

@implementation MHStoreController{
    NSInteger page;
    UIImageView *tapImageView;
    UIWindow *window;
    UIImageView *copyView;
    UIScrollView *scrollView;
    CGRect orginRect;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    UIFont *font;
    page = 1;
    if (iOS8) {
        font = [UIFont systemFontOfSize:17];
    }else{
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MColorTitle}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadStoreHomeNotification object:nil];
    [self searchVC];
    [self tableView];

    homeCommunity_id = [[MHAreaManager sharedManager] getCommunityData];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    // 只有登录了才允许刷数据  2017.11.22
   if([MHUserInfoManager sharedManager].login) [self.tableView.mj_header beginRefreshing];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - search代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    self.navigationController.navigationBar.shadowImage = self.shadowImage;
    [_resultVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_beginView);
    }];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;// 必须设置
    [_beginView.layer addAnimation:animation forKey:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 3;
    if (_model.recommend_merchant_list.count == 0) {
        count --;
    }
    if (_model.recommend_coupon_list.count == 0) {
        count --;
    }
    if (_model.coupon_list.list.count == 0){
        count --;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == [tableView numberOfSections]-1) {
        return _model.coupon_list.list.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (_model.recommend_merchant_list.count == 0 && _model.recommend_coupon_list.count){//无推荐商家，有推荐商品
        if (indexPath.section == 0) {
            return [self configureGoodsCellWithTableView:tableView IndexPath:indexPath];
        }
    }else if (_model.recommend_merchant_list.count  && _model.recommend_coupon_list.count == 0){//有推荐商家，无推荐商品
        if (indexPath.section == 0) {
            return [self configureShopCellWithTableView:tableView IndexPath:indexPath];
        }
    }else if (_model.recommend_merchant_list.count && _model.recommend_coupon_list.count){//有推荐商家，有推荐商品
        if (indexPath.section == 0) {
            return [self configureShopCellWithTableView:tableView IndexPath:indexPath];
        }else if (indexPath.section == 1){
            return [self configureGoodsCellWithTableView:tableView IndexPath:indexPath];
        }
    }
    
    if (indexPath.section == [tableView numberOfSections]-1) {
        MHStoreRecomGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreRecomGoodsListCellID];
        [cell mh_configCellWithInfor:_model.coupon_list.list[indexPath.row]];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHStoreHomeSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHStoreHomeSectionHeaderViewID];
    if (_model.recommend_merchant_list.count == 0 && _model.recommend_coupon_list.count){//无推荐商家，有推荐商品
        if (section == 0) {
            header.recommandLabel.text = @"推荐商品";
        }
    }else if (_model.recommend_merchant_list.count  && _model.recommend_coupon_list.count == 0){//有推荐商家，无推荐商品
        if (section == 0) {
            header.recommandLabel.text = @"推荐商家";
        }
    }else if (_model.recommend_merchant_list.count && _model.recommend_coupon_list.count){//有推荐商家，有推荐商品
        if (section == 0) {
            header.recommandLabel.text = @"推荐商家";
        }else if (section == 1){
            header.recommandLabel.text = @"推荐商品";
        }
    }
    
    if (section == [tableView numberOfSections]-1) {
        header.recommandLabel.text = @"商品列表";
        header.hideMore = YES;
    }else{
        header.hideMore = NO;
    }
    header.tag = section;
    header.delegate = self;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == [tableView numberOfSections]-1) {
        return nil;
    }else{
        MHStoreHomeSectionFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHStoreHomeSectionFooterViewID];
        return footer;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == [tableView numberOfSections]-1) {
        return 35;
    }else{
        return 49;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == [tableView numberOfSections]-1) {
        return 0;
    }else{
        return 10;
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [tableView numberOfSections]-1 ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MHStoreGoodsDetailViewController *vc = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:[_model.coupon_list.list[indexPath.row] coupon_id]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 商店详情
- (void)shopDetailWithIndex:(NSInteger)index{
    MHStoreShopDetailController *vc = [MHStoreShopDetailController new];
    NSNumber *merchant_id = [_model.recommend_merchant_list[index] merchant_id];
    vc.merchant_id = merchant_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goodsDetailWithIndex:(NSInteger)index{
    MHStoreGoodsDetailViewController *vc = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:[_model.recommend_coupon_list[index] coupon_id].integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看更多
- (void)checkMoreRecommandWithTag:(NSInteger)tag{
    
    if (_model.recommend_merchant_list.count == 0 && _model.recommend_coupon_list.count){//无推荐商家，有推荐商品
        if (tag == 0) {
            [self pushRecommandGoodsController];
        }
    }else if (_model.recommend_merchant_list.count  && _model.recommend_coupon_list.count == 0){//有推荐商家，无推荐商品
        if (tag == 0) {
            [self pushRecommandShopController];
        }
    }else if (_model.recommend_merchant_list.count && _model.recommend_coupon_list.count){//有推荐商家，有推荐商品
        if (tag == 0) {
            [self pushRecommandShopController];
        }else if (tag == 1){
            [self pushRecommandGoodsController];
        }
    }
    
    
}


#pragma mark - headerViewDelegate
- (void)didClickButtonAtIndex:(NSInteger)index{
    MHStHoBusinessModel *businessModel = _model.business_buttons[index];
    if (businessModel.is_enable == NO) {
        MHBuildingView *buildingView = [MHBuildingView buildingView];
        buildingView.frame = self.view.bounds;
        [WINDOW addSubview:buildingView];
    }else {
        if ([businessModel.name isEqualToString:@"分类"]) {
            MHGcTableController *vc = [[MHGcTableController alloc] init];
            vc.titleStr = @"分类";
            [MHHUDManager show];
            [MHStoreDataHandler postMallMerchantCategoryList:homeCommunity_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
                [MHHUDManager dismiss];
                if (success) {
                    vc.dataSource = [NSArray yy_modelArrayWithClass:[MHGcTableModel class] json:data[@"category_list"]];
                    [vc setDidSelectBlock:^(MHGcTableModel *model) {
                        MHStoreRecommandListController *storeVC  = [[MHStoreRecommandListController alloc] init];
                        storeVC.category_id = model.category_id;
                        storeVC.title = model.category_name;
                        [self.navigationController pushViewController:storeVC animated:YES];
                        
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [MHHUDManager showErrorText:errmsg];
                }
            }];
        }else if ([businessModel.name isEqualToString:@"扫一扫"]) {
            if([MHUserInfoManager sharedManager].isLogin){
                MHQRCodeController *qrcodeVC = [[MHQRCodeController alloc] initWithNibName:@"MHQRCodeController" bundle:nil];
                [self.navigationController pushViewController:qrcodeVC animated:YES];
            }else{
                [self presentLoginController];
            }

        }else if ([businessModel.name isEqualToString:@"我的订单"]){ // 周边商家订单
            if ([MHUserInfoManager sharedManager].isLogin) {
                MHMerchantOrderController *controller = [[MHMerchantOrderController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [self presentLoginController];
            }
        }else if ([businessModel.name isEqualToString:@"我是商家"]){  // 我是商家  user.is_merchant
            if ([MHUserInfoManager sharedManager].isLogin) {
                if ([[MHUserInfoManager sharedManager].is_merchant integerValue] == 1) {
                    MHMineMerchantController * vc = [MHMineMerchantController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [self mh_showRegisteredMerView];
                }
            }else{
                [self presentLoginController];
            }
        }
    }

}

- (void)didClickAddAtIndex:(NSInteger)index{
    MHStHoBannerAdModel *bannerModel =  _model.banner_list[index];
    if (bannerModel.link_type.integerValue == 0) { //内链
        if (bannerModel.link_target.integerValue == 0) { //商家
            MHStoreShopDetailController *vc = [[MHStoreShopDetailController alloc] init];
            vc.merchant_id = bannerModel.target_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{ //商品
            MHStoreGoodsDetailViewController *vc = [[MHStoreGoodsDetailViewController alloc] initWithCoupon_id:bannerModel.target_id.integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (bannerModel.link_type.integerValue == 1){ //外链
        
        HLWebViewController *vc = [[HLWebViewController alloc] initWithUrl:bannerModel.link];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (bannerModel.link_type.integerValue == 2){ // 无连接
        UIView *scrollView = _headerView.subviews.firstObject;
        UICollectionView *collectionView = scrollView.subviews.firstObject;
        UICollectionViewCell *cell = collectionView.visibleCells.firstObject;
        tapImageView = cell.contentView.subviews.firstObject;
        orginRect = tapImageView.frame;
        [self tap];
    }
}

#pragma mark - 按钮点击

- (void)tap{
    
    
    copyView = [[UIImageView alloc] initWithImage:tapImageView.image];
    copyView.userInteractionEnabled = YES;
    CGRect frame = [tapImageView.superview convertRect:tapImageView.frame toView:self.view];
    
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    copyView.frame = scrollView.bounds;
    [scrollView addSubview:copyView];
    
    window = [[UIWindow alloc] initWithFrame:self.view.bounds];
    window.windowLevel = UIWindowLevelAlert;
    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTwoTap)];
    twoTap.numberOfTapsRequired = 2;
    [copyView addGestureRecognizer:twoTap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTap)];
    [tap requireGestureRecognizerToFail:twoTap];
    [window addGestureRecognizer:tap];
    [vc.view addSubview:scrollView];
    
    self.view.hidden = YES;
    window.hidden = NO;
    window.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.nim_centerY = MScreenH/2;
    }];
    
}

- (void)windowTap{
    [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        scrollView.frame = orginRect;
        window.alpha = 0;
    } completion:^(BOOL finished) {
        self.view.hidden = NO;
        window.hidden = YES;
        window = nil;
    }];
    
}

- (void)imageTwoTap{
    if (scrollView.contentSize.width > MScreenW) {//缩小
        scrollView.contentSize = CGSizeMake(copyView.nim_size.width/2, copyView.nim_size.height/2);
        scrollView.nim_height /= 2;
        scrollView.nim_centerY = MScreenH/2;
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            copyView.nim_size = scrollView.contentSize;
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        scrollView.contentSize = CGSizeMake(copyView.nim_size.width*2, copyView.nim_size.height*2);
        scrollView.nim_height *= 2;
        scrollView.nim_centerY = MScreenH/2;
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            copyView.nim_size = scrollView.contentSize;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - private
- (void)loadData{
    page = 1;
    
    if ([JFAuthorizationStatusManager authorizationStatusMediaTypeMapIsOpen]) {
        [MHHUDManager show];
        [[JFMapManager manager] singlePositioningCompletionBlock:^(CLLocation *location, NSString *city, NSError *error) {
            CGFloat lat = location.coordinate.latitude;
            CGFloat lng = location.coordinate.longitude;
            if(lat && lng){
                _lat = [NSString stringWithFormat:@"%f",lat];
                _lng = [NSString stringWithFormat:@"%f",lng];
                _latNum = @(lat);
                _lngNum = @(lng);
            }
            
            [self loadDataWithLngLat];
            [MHHUDManager dismiss];
        }];
    }else{
        _lat = nil;
        _lng = nil;
        _latNum = nil;
        _lngNum = nil;
        [self loadDataWithLngLat];
    }
    
}

- (void)loadDataWithLngLat{
    [MHStoreDataHandler postMallMainWithCommunityID:homeCommunity_id GPSLng:_lng GPSLat:_lat Page:@(page) CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            _model = [MHStoreHomeModel yy_modelWithJSON:data];
            [self tableHeaderView];
            [self.tableView reloadData];
            if (_model.coupon_list.list.count) {
                _tableView.mj_footer = self.mj_footer;
            }
            if (_model.coupon_list.has_next ) {
                [_mj_footer resetNoMoreData];
                page = 2;
            }else{
                [_mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            if (_model.recommend_merchant_list.count == 0 && _model.recommend_coupon_list.count == 0 && _model.coupon_list.list.count == 0) {
                self.tableView.tableFooterView = self.footerView;
            }else{
                self.tableView.tableFooterView = nil;
            }
            
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadMoreData{
    
//    [MHHUDManager show];
    [MHStoreDataHandler postMallMainWithCommunityID:homeCommunity_id GPSLng:_lng GPSLat:_lat Page:@(page) CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
//        [MHHUDManager dismiss];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            NSArray *newGoods = [NSArray yy_modelArrayWithClass:[MHStoreRecomGoodsListModel class] json:data[@"coupon_list"][@"list"]];
            [_model.coupon_list.list addObjectsFromArray:newGoods];
            
            [self.tableView reloadData];
            
            _model.coupon_list.has_next = [data[@"coupon_list"][@"has_next"] boolValue];
            if (_model.coupon_list.has_next) {
                [_mj_footer resetNoMoreData];
                page ++;
            }else{
                [_mj_footer setState:MJRefreshStateNoMoreData];
            }
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)tableHeaderView{
    _headerView.model = _model;
    self.tableView.tableHeaderView = _headerView;
}

- (UITableViewCell *)configureShopCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    MHStHoRecommandShopCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStoreHomeRecommandCellID forIndexPath:indexPath];
    cell.model = _model;
    for (MHStHoRecommandShopView *shopView in cell.contentView.subviews) {
        if ([shopView isKindOfClass:[MHStHoRecommandShopView class]]) {
            shopView.delegate = self;
        }
    }
    
    return cell;
}

- (UITableViewCell *)configureGoodsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    MHStHoRecommandGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:MHStHoRecommandGoodsCellID forIndexPath:indexPath];
    cell.model = _model;
    for (MHStHoRecommandGoodsView *goodsView in cell.contentView.subviews) {
        if ([goodsView isKindOfClass:[MHStHoRecommandGoodsView class]]) {
            goodsView.delegate = self;
        }
    }
    return cell;
}

- (void)pushRecommandShopController{
    
    MHStoreRecommandListController *vc = [[MHStoreRecommandListController alloc] init];
    vc.title = @"推荐商家";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushRecommandGoodsController{
    MHStoreRecommedGoodsListViewController *recommendVC = [[MHStoreRecommedGoodsListViewController alloc] initWithcommunity_id:homeCommunity_id.integerValue keyword:nil type:MHStoreGoodsList_recommed];
    recommendVC.title = @"推荐商品";
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (void)reloadData{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - lazy

- (MJRefreshAutoFooter *)mj_footer{
    if (_mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"没有更多产品了" forState:MJRefreshStateNoMoreData];
        _mj_footer.backgroundColor = [UIColor whiteColor];
        _mj_footer = footer ;
    }
    return _mj_footer;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:_beginView.frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 126;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MHStHoRecommandShopCell class] forCellReuseIdentifier:MHStoreHomeRecommandCellID];
        [_tableView registerClass:[MHStHoRecommandGoodsCell class] forCellReuseIdentifier:MHStHoRecommandGoodsCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreRecomGoodsListCell" bundle:nil] forCellReuseIdentifier:MHStoreRecomGoodsListCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MHStoreHomeSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:MHStoreHomeSectionHeaderViewID];
        [_tableView registerClass:[MHStoreHomeSectionFooterView class] forHeaderFooterViewReuseIdentifier:MHStoreHomeSectionFooterViewID];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MHStoreHomeHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[MHStoreHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 318)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIImage *)shadowImage{
    if (_shadowImage == nil) {
        _shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(MScreenW, 0.5)];
    }
    return _shadowImage;
}

- (UISearchController *)searchVC{
    if (_searchVC == nil) {
        self.definesPresentationContext = YES;
        
        MHStoreSearchController *resultVC = [MHStoreSearchController new];
        _resultVC = resultVC;
        resultVC.storeVC = self;
        UISearchController *searchVC = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        resultVC.searchVC = searchVC;
        
        searchVC.view.backgroundColor = [UIColor whiteColor];
        searchVC.searchBar.frame = CGRectMake(0, 0, self.view.nim_width, 0);
        searchVC.searchBar.placeholder =@"输入商品名，商家名";
        searchVC.searchResultsUpdater = resultVC;
        searchVC.searchBar.searchBarStyle  = UISearchBarStyleMinimal;
        searchVC.searchBar.delegate = self;
        searchVC.hidesNavigationBarDuringPresentation = NO;
        searchVC.searchBar.tintColor = MColorTitle;
        if (iOS8) {
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        }
        
        self.navigationItem.titleView = searchVC.searchBar;
        [self.navigationController.navigationBar setNeedsLayout];
        [self.navigationController.navigationBar layoutIfNeeded];
        
        _searchVC = searchVC;
        [self beginView];
    }
    return _searchVC;
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
        label.text = @"暂无商家上架商品";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = MColorFootnote2;
        [label sizeToFit];
        label.nim_centerX = self.view.nim_width/2;
        label.nim_top = imageView.nim_bottom+8;
        [_footerView addSubview:label];
        
    }
    return _footerView;
}

- (UIView *)beginView{
    if (_beginView == nil) {
        CGFloat navbarH = _searchVC.searchBar.nim_height + 20;
        CGFloat y = navbarH;
        if (iOS8) {
            y = 0;
        }
        UIView *beginView = [[UIView alloc] initWithFrame:CGRectMake(0, y, MScreenW, MScreenH - navbarH - 49)];
        beginView.backgroundColor = MColorBackgroud;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StoreSearch"]];
        imageView.nim_size = CGSizeMake(120, 120);
        imageView.contentMode = UIViewContentModeCenter;
        [beginView addSubview:imageView];
        imageView.nim_centerX = beginView.nim_width/2;
        imageView.nim_top = 40;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"搜索相关商品或商家";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = MColorFootnote2;
        [beginView addSubview:label];
        [label sizeToFit];
        label.nim_centerX = beginView.nim_width/2;
        label.nim_top = imageView.nim_bottom;
        [_searchVC.view insertSubview:beginView atIndex:0];
        _beginView = beginView;
    }
    return _beginView;
}

@end






