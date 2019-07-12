//
//  MHHomeServiceController.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeServiceController.h"
#import "MHNavigationControllerManager.h"

#import "MHHoCommunityAnnouncementController.h"
#import "HLWebViewController.h"
#import "MHLoSetPlotController.h"
#import "MHHomePayNoteController.h"
#import "MHQRCodeController.h"
#import "MHHoFoodDeliveryController.h"
#import "MHHoFooDeliUnAllowController.h"

#import "MHMacros.h"
#import "UIViewController+HLNavigation.h"

#import "MHHomeServiceCollectionViewFlowLayout.h"
#import "MHHUDManager.h"
#import "MHWeakStrongDefine.h"
#import "UIViewController+HLStoryBoard.h"
#import "UIImage+Color.h"

#import "Masonry.h"
#import "MHUserInfoManager.h"
#import "MHHomeRequest.h"
#import "YYModel.h"
#import "MHMineRoomModel.h"

#import "MHHomeCertificationView.h"
#import "MHAlertView.h"
#import "MHHomeButtonCell.h"
#import "MHBuildingView.h"

#import "MHReportRepairMainViewController.h"
#import "MHHomeRequest.h"
#import "MHHUDManager.h"
#import "MHHomeFunctionalModulesModel.h"
#import "MHHomeMoreFunctionalModulesModel.h"
#import "UIImageView+WebCache.h"

static NSString *const kMHHomeHostRouteUrl = @"wonderfullife://com.junfuns.wonderfullife/home/";
//controller path
static NSString *const kMHHomePayNoteController = @"MHHomePayNoteController"; //物业缴费
static NSString *const kMHDutyFreeMallController = @"MHDutyFreeMallController"; //免息商城
static NSString *const kMHHappyTreasureController = @"MHHappyTreasureController"; //美好财富
static NSString *const kMHHomeFoodDeliveryController = @"MHHoFoodDeliveryController"; //食堂送餐
static NSString *const kMHHoCommunityAnnouncementController = @"MHHoCommunityAnnouncementController"; //小区公告
static NSString *const kMHReportRepairMainViewController = @"MHReportRepairMainViewController"; //投诉报修
static NSString *const kMHQRCodeController = @"MHQRCodeController"; //扫码支付

//食堂送餐指定号码
static NSString *const kMHHomeFoodDeliveryPhone1 = @"18820808182";
static NSString *const kMHHomeFoodDeliveryPhone2 = @"13922202727";
static NSString *const kMHHomeFoodDeliveryPhone3 = @"18285049280";

@interface MHHomeServiceController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<MHHomeMoreFunctionalModulesModel*>  *moreFunctionalArray;

@end

@implementation MHHomeServiceController

static NSString *kHomeCollectionFootKey = @"kHomeServiceCollectionFootKey";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"美好服务";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.community_id = [MHUserInfoManager sharedManager].community_id;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:MColorTitle}];
    [self.view addSubview:self.collectionView];
    [self loadServiceDatas];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator];
    
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [cancel setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    [cancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(popLastController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popLastController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SetUI

- (void)addBuildView{
    MHBuildingView *buildingView = [MHBuildingView buildingView];
    buildingView.frame = CGRectMake(0, 0, MScreenW, MScreenH);
    [WINDOW addSubview:buildingView];
}


- (void)loadServiceDatas {
    [MHHUDManager show];
    MHWeakify(self)
    [MHHomeRequest loadHomeMoreFunctionalModules:self.community_id callBack:^(BOOL success,
                                                                              NSArray<MHHomeMoreFunctionalModulesModel *> *functionalPropertyList,
                                                                              NSString *errmsg) {
        [MHHUDManager dismiss];
        MHStrongify(self)
        if (success) {

            self.moreFunctionalArray = nil;
            self.moreFunctionalArray = functionalPropertyList;
            
            for (MHHomeMoreFunctionalModulesModel *model in functionalPropertyList) {
                NSMutableArray *mut_array = [NSMutableArray arrayWithArray:model.service_list];
                if (mut_array.count%4 != 0) {
                    NSInteger addObjectsNum = 4 - mut_array.count%4;
                    for (int i = 0; i < addObjectsNum ; i ++) {
                        [mut_array addObject:[self emptyDictionary]];
                    }
                }
                model.service_list = mut_array;
            }
            
            
            [self.collectionView reloadData];
        } else {
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (NSDictionary *)emptyDictionary {
    return @{@"function_code_ios@":@"",
             @"function_name@":@"",
             @"function_icon_url@":@"",
             @"is_under_construction@":@1};
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
   [self didSelectedfunctionalModulesAtModel:self.moreFunctionalArray[indexPath.section].service_list[indexPath.row]];
}

- (void)didSelectedfunctionalModulesAtModel:(NSDictionary*)model {
    NSString *function_name = model[@"function_name"];
    if (!function_name) {
        return;
    }
    if ([model[@"is_under_construction"] boolValue]) {//该功能是否在维修中
        [self addBuildView];
        return;
    }
    NSString *controllerName = [self nextControllerFromUrl:model[@"function_code_ios"]];
    if ([controllerName isEqualToString:kMHHomePayNoteController]) {//物业缴费
        [self didSelectedPropertyFeeItem];
        return;
    }
    if ([controllerName isEqualToString:kMHHomeFoodDeliveryController]) {//食堂送餐
        [self didSelectedFoodDeliveryController];
        return;
    }
    if (![@[kMHHomePayNoteController,kMHHoCommunityAnnouncementController,kMHReportRepairMainViewController,kMHQRCodeController]containsObject:controllerName]) {
        [self addBuildView];
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
    if (property_status == 0 || property_status == 1) {//未认证
        [[MHAlertView sharedInstance] normalAlertViewTitle:@"暂无权限使用该功能" message:@"您还没认证住户身份，需要先完成住户认证才能使用物业服务功能" LeftTitle:@"稍后再说" RightTitle:@"马上认证" leftHandler:^{
        } rightHandler:^{
            if (property_status == 0) {
                MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:NSStringFromClass([MHLoSetPlotController class])];
                vc.setType = MHLoSetPlotTypeCertifi;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MHHUDManager showText:@"您已提交住户认证，请耐心等待审核结果"];
                //self.tabBarController.selectedIndex =  self.tabBarController.viewControllers.count - 1;
            }} rightButtonColor:MColorConfirmBtn];
    }else if (property_status == 2){
        [MHHUDManager show];
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
            vc.room = array.firstObject;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

- (NSString *)nextControllerFromUrl:(NSString*)url {
    return [url substringFromIndex:kMHHomeHostRouteUrl.length];
}


- (void)didSelectedFoodDeliveryController {
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if ([@[kMHHomeFoodDeliveryPhone1,kMHHomeFoodDeliveryPhone2,kMHHomeFoodDeliveryPhone3] containsObject:user.phone_number]) {//可送餐
        [self.navigationController pushViewController:[MHHoFoodDeliveryController new] animated:YES];
    }else { //不可送餐
        [self.navigationController pushViewController:[MHHoFooDeliUnAllowController new] animated:YES];
    }
}





- (void)openWeb:(NSString *)url isHiddenCloseBtn:(BOOL)isClose webType:(HLWebViewType)type{
    HLWebViewController *vc = [[HLWebViewController alloc]initWithUrl:url webType:type];
    vc.hiddenClosedButton = isClose ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 添加房间
- (void)addRoom{
    MHLoSetPlotController *loSetVc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:@"MHLoSetPlotController"];
    loSetVc.setType = MHLoSetPlotTypePay;
    loSetVc.fromHome = YES;
    loSetVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loSetVc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.moreFunctionalArray[section].service_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHHomeButtonCell *cell = [MHHomeButtonCell cellWithCollectionView:collectionView indexPath:indexPath homeButtonType:MHHomeButtonTypeServer];

    NSDictionary *model ;
    model = self.moreFunctionalArray[indexPath.section].service_list[indexPath.row];
    [cell.mh_imageView sd_setImageWithURL:[NSURL URLWithString:model[@"function_icon_url"]]];
    [cell.mh_titleLabel setText:model[@"function_name"]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.moreFunctionalArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame)/4, 114);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *sectionView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeCollectionFootKey forIndexPath:indexPath];
    [sectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 200, 20)];
    title.textColor = MColorToRGB(0x8492A6);
    title.font = [UIFont systemFontOfSize:14.0];
    
    title.text = self.moreFunctionalArray[indexPath.section].service_name;
    [sectionView addSubview:title];
    return sectionView;
}


#pragma mark - Setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        MHHomeServiceCollectionViewFlowLayout  *layout = [[MHHomeServiceCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, MScreenW, MScreenH - 64) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:MRGBColor(250, 251, 252)];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MHHomeButtonCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MHHomeButtonCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeCollectionFootKey];
    }return _collectionView;
}


@end
