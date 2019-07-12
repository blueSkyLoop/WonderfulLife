//
//  MHHomeController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeController.h"
#import "MHHomeVolController.h"
#import "MHLoSetPlotController.h"
#import "MHHomePayNoteController.h"
#import "HLWebViewController.h"
#import "MHHomeServiceController.h"
#import "MHQRCodeController.h"

#import "MHHoFoodDeliveryController.h"
#import "MHHoFooDeliUnAllowController.h"

#import "MHTabBarControllerManager+StoreSwitch.h"

#import "MHHomeCertificationView.h"
#import "MHRefreshGifHeader.h"

#import "MHHomeRequest.h"
#import "MHHomeArticle.h"
#import "MHHomeBannerAd.h"
#import "MHCityModel.h"
#import "MHCommunityModel.h"
#import "MHHomeHTMLModel.h"
#import "MHMineRoomModel.h"

#import "MHLoginRequestHandler.h"

#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import <HLCategory/UIViewController+HLStoryBoard.h>
#import "UIButton+MHImageUpTitleDown.h"
#import "UIViewController+PresentLoginController.h"
#import "MJRefresh.h"
#import "MHUserInfoManager.h"
#import "MHAreaManager.h"
#import "MHConstSDKConfig.h"
#import "MHBuildingView.h"
#import "MHConst.h"
#import "MHMacros.h"
#import "NSObject+isNull.h"
#import "YYModel.h"
#import "MHHomeRoomModel.h"

#import "MHHoCommunityAnnouncementController.h"
#import "MHHoMsgNotifiTableViewController.h"

#import "MHLoPlotSltController.h"

#import "MHAlertView.h"
#import "UIViewController+UMengAnalytics.h"
#import "NSObject+CurrentController.h"
#import "MHReportRepairMainViewController.h"
#import "MHNavigationControllerManager.h"


#import "MHHomeViewModel.h"
#import "MHHomeFunctionalModulesModel.h"
#import "MHHomeCollectionViewCellProtocol.h"
#import "UICollectionViewCell_MHHomeCollectionView.h"
#import "UIViewController+HLNavigation.h"




//controller path
static NSString *const kMHHomePayNoteController = @"MHHomePayNoteController"; //物业缴费
static NSString *const kMHDutyFreeMallController = @"MHDutyFreeMallController"; //免息商城
static NSString *const kMHHappyTreasureController = @"MHHappyTreasureController"; //美好财富
static NSString *const kMHHomeFoodDeliveryController = @"MHHoFoodDeliveryController"; //食堂送餐
static NSString *const kMHHoCommunityAnnouncementController = @"MHHoCommunityAnnouncementController"; //小区公告
static NSString *const kMHReportRepairMainViewController = @"MHReportRepairMainViewController"; //投诉报修
static NSString *const kMHQRCodeController = @"MHQRCodeController"; //扫码支付
static NSString *const kMHHomeServiceController = @"MHHomeServiceController"; //更多

//collectionview footer or header identifier
static NSString *const kMHHomeCollectionFooterView = @"UICollectionFooterView";
static NSString *const kMHHomeComActivityReusableView = @"MHHomeComActivityReusableView";

//alert tips contents
static NSString *const kMHAlertPropertyFeeTitle = @"暂无权限使用该功能";
static NSString *const kMHAlertPropertyFeeLeftTitleText = @"稍后再说";
static NSString *const kMHAlertPropertyFeeRightTitleText = @"马上认证";
static NSString *const kMHAlertPropertyFeeErrorText = @"您已提交住户认证，请耐心等待审核结果";
static NSString *const kMHAlertPropertyFeeContentText = @"您还没认证住户身份，需要先完成住户认证才能使用物业服务功能";

//食堂送餐指定号码
static NSString *const kMHHomeFoodDeliveryPhone1 = @"18820808182";
static NSString *const kMHHomeFoodDeliveryPhone2 = @"13922202727";
static NSString *const kMHHomeFoodDeliveryPhone3 = @"18285049280";

static BOOL chooseMyCommunity = NO;

NSNumber *homeCommunity_id = nil;

@interface MHHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,MHHomeCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mh_titleButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UIImageView *dot;

@property (strong,nonatomic) MHHomeArticle *volunteerTopNews;
@property (strong,nonatomic) NSArray<MHHomeBannerAd *>  *bannerList;
@property (strong,nonatomic) NSMutableArray<MHHomeArticle *> *communityNews;

@property (nonatomic, copy) NSString *next_page;
@property (nonatomic, copy) NSString *titleStr ;

@property (nonatomic,strong) MHHomeHTMLModel *htmlModel;
@property (nonatomic,strong) MHHomeViewModel *viewModel;
@end

@implementation MHHomeController

#pragma mark - Life Cycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static BOOL chooseMyCommunity ;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigation];
    [self registerCollectionCellNib];
    [self registerNotificationCenter];
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (user.is_need_to_notice.integerValue) {
        MHWeakify(self)
        [WINDOW addSubview:[MHHomeCertificationView awakeFromNibWithCaetificationAction:^{
            MHStrongify(self)
            MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:NSStringFromClass([MHLoSetPlotController class])];
            vc.setType = MHLoSetPlotTypeCertifi;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([MHUserInfoManager sharedManager].isLogin) {
        [MHHomeRequest getReddotHomeCallback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            if (success) {
                self.dot.hidden = ![data[@"has_notification"] integerValue];
            }}];
    }else{
        self.dot.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Register NotificationCenter
- (void)registerNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataNotificationAction) name:kReloadHomeControllerDataNotification object:nil];
}

#pragma mark -
#pragma mark - 新代码区
#pragma mark - Register CollectionCellNib
- (void)registerCollectionCellNib {
    for(NSString *className in self.viewModel.nibCellNames){
        [self.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
    }
    [self.collectionView registerNib:[UINib nibWithNibName:kMHHomeComActivityReusableView bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMHHomeComActivityReusableView];//首页社区动态模块的标题
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMHHomeCollectionFooterView];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    mjheader.stateLabel.hidden = YES;
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = mjheader;
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.nibCellNames.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) { return self.viewModel.dataSource_functionalmodules.count;}//首页功能模块
    if (section == 4) { return self.communityNews.count;}//首页社区动态模块
    if (section == 3) { if(self.volunteerTopNews) {return 1;} return 0;}// 没有 “志愿者风采” 的话 数量给 0
    return [self.viewModel.displayLimitNumbers[section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.viewModel.nibCellNames[indexPath.section];
    UICollectionViewCell<MHHomeCollectionViewCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section == 0) {//首页广告模块
        [cell mh_collectionViewCellWithModel:self.bannerList];
    }else if (indexPath.section == 1) {//首页功能模块
        [cell mh_collectionViewCellWithModel:self.viewModel.dataSource_functionalmodules[indexPath.row]];
    }else if (indexPath.section == 2) {//首页社区关怀模块
        [cell mh_collectionViewCellWithModel:self.viewModel.dataSource_comcaremodules[indexPath.row]];
    }else if (indexPath.section == 3) {//首页志愿者风采模块
        [cell mh_collectionViewCellWithModel:self.volunteerTopNews];
    }else if (indexPath.section == 4) {//首页社区动态模块
        [cell mh_collectionViewCellWithModel:self.communityNews[indexPath.row]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return CGSizeMake(MScreenW, 168); //首页广告模块
    else if (indexPath.section == 1&&indexPath.row < 4) return CGSizeMake(CGRectGetWidth(collectionView.frame)/4, 104); //首页功能模块1
    else if (indexPath.section == 1&&indexPath.row >= 4) return CGSizeMake(CGRectGetWidth(collectionView.frame)/4, 118); //首页功能模块2底部增加白色显示，对应UI
    else if (indexPath.section == 2) return CGSizeMake(CGRectGetWidth(collectionView.frame)/2-0.5, 92); //首页社区关怀模块
    else if (indexPath.section == 3&&self.volunteerTopNews) return CGSizeMake(MScreenW, 282); //首页志愿者风采模块,显示“志愿者风采”
    else return CGSizeMake(MScreenW, 104); //首页社区动态模块
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0||section == 4) {//首页广告模块与社区动态模块 底部不需要显示灰色间距
        return CGSizeMake(MScreenW, 0);
    }else if (section == 3&&!self.volunteerTopNews) {
        return CGSizeMake(MScreenW, 0);
    }else{
        return CGSizeMake(MScreenW, 12);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 4) {//首页社区动态模块的标题
        return CGSizeMake(MScreenW, 54);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) { return 0.5;} else { return 0;}//首页社区关怀模块,显示空隙1分割线
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2){return 0.5;} else{return 0;}//首页社区关怀模块,显示空隙1分割线
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]&&indexPath.section == 4) {//首页社区动态模块的标题
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMHHomeComActivityReusableView forIndexPath:indexPath];
        return view;
    }else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kMHHomeCollectionFooterView forIndexPath:indexPath];
        return footerview;
    }
    return nil;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {//首页功能模块
        [self didSelectedfunctionalModulesAtIndex:indexPath.row];
    }else if (indexPath.section == 2) {//首页社区关怀模块
        [self didSelectFacilityItem:indexPath.row];
    }else if (indexPath.section == 4) {//首页社区动态模块
        NSString *url = self.communityNews[indexPath.row].article_url;
        if (url.length) { [self openWeb:url isHiddenCloseBtn:NO webType:HLWebViewTypeNormal]; }
    }
}

#pragma mark - MHHomeCollectionViewCellDelegate
- (void)mh_collectionViewCell:(id)cell didSelectedAdsItemAtIndex:(NSInteger)index{//点击广告
    if (self.bannerList.count) { // 不加判断会闪退
        MHHomeBannerAd *banner = self.bannerList[index];
        NSString *url = banner.link_url;
        [self openWeb:url isHiddenCloseBtn:NO webType:HLWebViewTypeNormal];
    }
}

- (void)mh_collectionViewCellDidSelectedComactivitiesHeaderMore{//首页志愿者风采模块的更多
    MHHomeVolController *vc = [[MHHomeVolController alloc]init];
    vc.community_id = homeCommunity_id ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mh_collectionViewCellDidSelectedComactivitiesHeaderImage{//首页志愿者风采模块的图片跳转
    NSString *url = self.volunteerTopNews.article_url;
    [self openWeb:url isHiddenCloseBtn:NO webType:HLWebViewTypeNormal];
}

- (void)didSelectedfunctionalModulesAtIndex:(NSInteger)index {
    MHHomeFunctionalModulesModel *model = self.viewModel.dataSource_functionalmodules[index];
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (!model.function_name||[model.function_name isEqualToString:@""]) {
        return;
    }
    NSString *controllerName = [self.viewModel nextControllerFromUrl:model.function_code_ios];
    if (!user.isLogin&&[@[kMHHomePayNoteController,kMHReportRepairMainViewController,kMHQRCodeController,kMHHomeServiceController,kMHDutyFreeMallController]containsObject:controllerName]) {//物业缴费、投诉报修、扫一扫、免费送饭需要用户登录才可以登录，
        [self presentLoginController];
        return;
    }
    if ([model.is_under_construction boolValue]) {//该功能是否在维修中
        [self addMHBuildingView];
        return;
    }
    if ([controllerName isEqualToString:kMHHomePayNoteController]) {//物业缴费
        [self didSelectedPropertyFeeItem];
        return;
    }
    if ([controllerName isEqualToString:kMHHomeFoodDeliveryController]) {//食堂送餐
        [self didSelectedFoodDeliveryController];
        return;
    }
    if ([@[kMHDutyFreeMallController,kMHHappyTreasureController] containsObject:controllerName]) {// 美好财富&免息商城
        [self htlmRequest:model.function_name];
        return;
    }
    if (![@[kMHHomePayNoteController,kMHHoCommunityAnnouncementController,kMHReportRepairMainViewController,kMHQRCodeController,kMHHomeServiceController]containsObject:controllerName]) {
        [self addMHBuildingView];//此处是为了避免测试乱开启权限，进入一些根本没有的界面导致闪退。后续要是增加功能了，这里需要更改相应的代码。
        return;
    }
    
    UIViewController *controller = [[NSClassFromString(controllerName) alloc]init];
    if([controllerName isEqualToString:kMHReportRepairMainViewController]){
        [self hl_setNavigationItemColor:[UIColor whiteColor]];
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didSelectedPropertyFeeItem {// 物业缴费
    MHUserInfoManager *info = [MHUserInfoManager sharedManager];
    NSInteger property_status = info.validate_status.integerValue;
    if (property_status == 0 || property_status == 1) {//未认证o
        [[MHAlertView sharedInstance] normalAlertViewTitle:kMHAlertPropertyFeeTitle message:kMHAlertPropertyFeeContentText  LeftTitle:kMHAlertPropertyFeeLeftTitleText RightTitle:kMHAlertPropertyFeeRightTitleText leftHandler:^{
        } rightHandler:^{
            if (property_status == 0) {
                MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:NSStringFromClass([MHLoSetPlotController class])];
                vc.setType = MHLoSetPlotTypeCertifi;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                self.tabBarController.selectedIndex = self.tabBarController.viewControllers.count - 1;
            }} rightButtonColor:MColorConfirmBtn];
    }else if (property_status == 2){
        [MHHUDManager show]; //检查用户认证的房间信息
        [MHHomeRequest checkUserRoomsInfoCallback:^(NSDictionary *data) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[MHMineRoomModel class] json:data[@"room_list"]];
            if (temp.count) [self checkRoomPaidTimeoutWithRoom:temp];
        }];
    }
}

//2018.01.03 新增缴费的房间是否在关账期间内，若是，则不让进去缴费界面
- (void)checkRoomPaidTimeoutWithRoom:(NSArray*)array {
    MHMineRoomModel *model = array.firstObject;
    [MHHomeRequest checkRoomPaidTimeoutWithRoomID:model.struct_id callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            MHHomePayNoteController *vc = [[MHHomePayNoteController alloc] init];
            vc.hasMoreRoom = array.count > 1;
            vc.hidesBottomBarWhenPushed = YES;
            vc.room = array.firstObject;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)didSelectedFoodDeliveryController {
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if ([@[kMHHomeFoodDeliveryPhone1,kMHHomeFoodDeliveryPhone2,kMHHomeFoodDeliveryPhone3] containsObject:user.phone_number]) {//可送餐
        [self.navigationController pushViewController:[MHHoFoodDeliveryController new] animated:YES];
    }else { //不可送餐
        [self.navigationController pushViewController:[MHHoFooDeliUnAllowController new] animated:YES];
    }
}


#pragma mark -
#pragma mark - 旧代码区
#pragma mark - SetUI
- (void)configureNavigation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chooseMyCommunity = YES ;
    });
    if ([MHUserInfoManager sharedManager].isLogin && [[MHUserInfoManager sharedManager].validate_status integerValue] ==2 && chooseMyCommunity) { // 首次进入 已登录的认证住户切换到所在的住宅地区
        self.titleStr = [MHUserInfoManager sharedManager].community_name;
        homeCommunity_id = [MHUserInfoManager sharedManager].community_id ;
        chooseMyCommunity = NO ;
    }else {
        [self setCommunityData];
    }
    [self.mh_titleButton mh_setLeftTitle:self.titleStr rightImage:[UIImage imageNamed:@"MHHomeTitltButtonIcon"]];
    self.mh_titleButton.adjustsImageWhenHighlighted = NO;
}


// 取缓存地区
- (void)setCommunityData {
    // 取缓存
    NSString *cacheCity     = [MHAreaManager sharedManager].community_name ;
    NSNumber *cacheCity_id  = [MHAreaManager sharedManager].community_id ;
    NSString *myCity        = [MHUserInfoManager sharedManager].community_name ;
    NSNumber *myCity_id     = [MHUserInfoManager sharedManager].community_id ;
    
    if (![NSObject isNull:cacheCity] && ![NSObject isNull:cacheCity_id]) { // 判断是否有缓存,有就取缓存
        self.titleStr = cacheCity ;
        homeCommunity_id =  cacheCity_id;
    }else if (![NSObject isNull:myCity] && ![NSObject isNull:myCity_id]) {  // 取已登录的 地区信息
        self.titleStr = myCity ;
        homeCommunity_id =  myCity_id;
    }else {
        self.titleStr = @"选择小区";
        homeCommunity_id = @10086;
    }
}

#pragma mark - Notification
- (void)reloadDataNotificationAction{
    [self configureNavigation];
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark -  Request
- (void)loadNetData {
    MHWeakify(self)
    [MHHomeRequest loadHomeTableDataWithPage:nil communityId:homeCommunity_id callBack:^(BOOL success, NSArray<MHHomeBannerAd *> *bannerList, MHHomeArticle *volunteerTopNews, NSArray<MHHomeArticle *> *communityNews, NSString *errmsg,NSString *next_page,NSArray<MHHomeFunctionalModulesModel*> *function_list) {
        MHStrongify(self)
        [self.collectionView.mj_header endRefreshing];
        if (success) {
            [self.viewModel.dataSource_functionalmodules removeAllObjects];
            self.viewModel.dataSource_functionalmodules = [NSMutableArray arrayWithArray:function_list];
            self.bannerList = bannerList;
            self.volunteerTopNews = volunteerTopNews;
            self.communityNews = [NSMutableArray arrayWithArray:communityNews];
            [self.collectionView reloadData];
            self.next_page = next_page;
            if (next_page) {
                self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            } else {
                self.collectionView.mj_footer = nil;
            }
        } else {
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (void)loadMoreData {
    MHWeakify(self)
    [MHHomeRequest loadHomeTableDataWithPage:self.next_page  communityId:homeCommunity_id callBack:^(BOOL success, NSArray<MHHomeBannerAd *> *bannerList, MHHomeArticle *volunteerTopNews, NSArray<MHHomeArticle *> *communityNews, NSString *errmsg,NSString *next_page,NSArray<MHHomeFunctionalModulesModel*> *function_list) {
        MHStrongify(self)
        if (success) {
            [self.communityNews addObjectsFromArray:communityNews];
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:4]];
            }];
            self.next_page = next_page;
            if (next_page) {
                [self.collectionView.mj_footer endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.collectionView.mj_footer endRefreshing];
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}


#pragma mark - Button Event
- (IBAction)chooseCity:(id)sender {
    MHLoPlotSltController *vc = [MHLoPlotSltController hl_controllerWithIdentifier:@"MHLoPlotSltController" storyBoardName:@"MHLoSetPlotController"];
    vc.sltType = MHLoPlotSltTypeCity;
    MHWeakify(self)
    vc.callBack = ^(MHCityModel *city, MHCommunityModel *community) {
        MHStrongify(self)
        // navBar
        [self.mh_titleButton mh_setLeftTitle:community.community_name rightImage:[UIImage imageNamed:@"MHHomeTitltButtonIcon"]];
        homeCommunity_id = community.community_id;
        
        // 记录上一次选择的小区
        [MHUserInfoManager sharedManager].community_id      = community.community_id ;
        [MHUserInfoManager sharedManager].community_name    = community.community_name ;
        [[MHUserInfoManager sharedManager] saveUserInfoData];
        
        NSDictionary *dic = @{@"community_name":community.community_name,@"community_id":community.community_id};
        [[MHAreaManager sharedManager] analyzingData:dic];
        
        [self.collectionView.mj_header beginRefreshing];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadStoreHomeNotification object:nil];
        
        
        [MHHUDManager show];
        [MHLoginRequestHandler communitySwitchWithCommunity:community success:^(BOOL success) {
            [MHHUDManager dismiss];
            [[MHTabBarControllerManager getMHTabbar] mh_reloadChildControllers];
        } failure:^(NSString *errmsg) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:errmsg];
        }];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.topline.hidden = scrollView.contentOffset.y<=0;
}

#pragma mark - Private Method

- (void)htlmRequest:(NSString *)title{
    if (!self.htmlModel) {
        [MHHUDManager show];
        [MHHomeRequest postHTMLUrlControlIsShowWithBlock:^(BOOL success, MHHomeHTMLModel *model, NSString *errmsg) {
            if (success) {
                self.htmlModel = model ;
                [self htlmShow:title];
            }else{
                [self addMHBuildingView];
            }
            [MHHUDManager dismiss];
        }];
    }else{
        [self htlmShow:title];
    }
}

- (void)htlmShow:(NSString *)title {
    if ([title isEqualToString:@"美好财富"] && self.htmlModel.paying_money_enable == 1){// 美好财富
        [self addMHBuildingView];
        //        [self openWeb:self.htmlModel.paying_money_url isHiddenCloseBtn:YES webType:HLWebViewTypeH5CanBack];
        return;
    }else if ([title isEqualToString:@"免息商城"] && self.htmlModel.free_interest_shopping_enable == 1 ){// 免息商城
        [self addMHBuildingView];
        //        [self openWeb:self.htmlModel.free_interest_shopping_url isHiddenCloseBtn:YES webType:HLWebViewTypeH5CanBack];
        return;
    }else {
        [self addMHBuildingView];
    }
}

- (void)addMHBuildingView{
    MHBuildingView *buildingView = [MHBuildingView buildingView];
    buildingView.frame = self.view.bounds;
    [WINDOW addSubview:buildingView];
}

- (void)didSelectFacilityItem:(NSInteger)item {
    NSString *url;
    switch (item) {
        case 0:
            url = [NSString stringWithFormat:@"%@h5/happyDining",baseUrl];
            break;
        case 1:
            url = [NSString stringWithFormat:@"%@h5/fourHalfClass",baseUrl];
            break;
        case 2:
            url = [NSString stringWithFormat:@"%@h5/oldmanSchool",baseUrl];
            break;
        case 3:
            url = [NSString stringWithFormat:@"%@h5/obligationHaircut",baseUrl];
            break;
        default:
            break;
    }
    [self openWeb:url isHiddenCloseBtn:NO webType:HLWebViewTypeNormal];
}

- (void)openWeb:(NSString *)url isHiddenCloseBtn:(BOOL)isClose webType:(HLWebViewType)type{
    HLWebViewController *vc = [[HLWebViewController alloc]initWithUrl:url webType:type];
    vc.hiddenClosedButton = isClose ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


// 消息列表
- (IBAction)notificationButtonDidClick {
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (user.isLogin) {
        MHHoMsgNotifiTableViewController *vc = [MHHoMsgNotifiTableViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self presentLoginController];
    }
}

#pragma mark - Getter
- (MHHomeViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [MHHomeViewModel new];
    }
    return _viewModel;
}
@end
