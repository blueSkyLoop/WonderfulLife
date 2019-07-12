//
//  MHMineMerchantController.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerchantController.h"
#import "MHMineColQrCodeController.h"   // 收款码
#import "MHMineInputFieldController.h" // 扫码收款
#import "MHMineMerFinListController.h"  // 财务报表
#import "MHStoreShopDetailController.h" // 商家详情
#import "MHStoreFeedbackViewController.h" // 反馈
#import "MHMerchantOrderManagerController.h" //订单管理
#import "MHMerchantRefundDoingController.h" //处理退款
#import "MHMineMerWithdrawViewController.h" //提现

#import "UIViewController+PresentPayIncomResultController.h"

#import "MHMineMerchantViewModel.h"
#import "MHMineMerchantDelegateModel.h"
#import "MHMineMerchantInfoModel.h"
#import "MHMineMerchantPayModel.h"

#import "MHVoSeverPageCell.h"
#import "MHAlertSheetView.h"
#import "MHAlertView.h"

#import <Masonry.h>
#import "MHMacros.h"
#import "UIViewController+HLNavigation.h"
#import "UIViewController+MHTelephone.h"
#import "UINavigationController+MHDirectPop.h"

#import "MHWeakStrongDefine.h"
#import "MHMineMerchantFuncCountruct.h"
#import "MHQRCodeController.h"

@interface MHMineMerchantController ()

/** 商家ID*/
@property (nonatomic, strong) NSNumber  *merchant_id; // 缓存 id

/** collectionView */
@property (strong,nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong)MHMineMerchantDelegateModel *delegateModel;
@property (nonatomic,strong)MHMineMerchantViewModel *viewModel;

@end

@implementation MHMineMerchantController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    /*
     这个设置是跟随整个导航的，在这里设置之后，应该考虑别的界面，这个界面出现的时候设置，相应的应该在这个界面消失的时候恢复，不然从这个界面出去的都无法看到标题，全是白色，在本界面的事情在本界面解决，不要影响其它界面
     */
    //本页面无需设置title 不必设置
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //恢复title颜色，以免本界面设置的白色影响到其它界面
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor blackColor]}];
}

#pragma mark - Private

- (void)bindViewModel {
    MHWeakify(self)
    [self.viewModel.refreshSubject subscribeNext:^(id  _Nullable x) {
        MHStrongify(self);
        [self.collectionView reloadData];
        
    }];
    
    // 获取商家主页数据
    [self.viewModel.serverCommand.executionSignals.switchToLatest subscribeNext:^(MHMineMerchantInfoModel *model) {
        MHStrongify(self);
        self.viewModel.infoModel = model;
        [self.delegateModel.headView reloadDataWitModel:model];
        if (model.my_merchant_list.count >=2 )[self addRightBar]; // 有绑定多个商家才显示切换按钮
    }];
     [self.viewModel.serverCommand execute:self.viewModel.infoModel.merchant_id];
    //代理
    self.delegateModel = [[MHMineMerchantDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure collectionView:self.collectionView cellClassNames:@[NSStringFromClass(MHVoSeverPageCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, MHMineMerchantFunctiomModel *cellModel) {
        MHStrongify(self);
        [self openControllerWithType:cellModel.type];
    }];
    // 进入商家资料详情页
    self.delegateModel.block = ^(MHMineMerchantDelegateModel *model){
        MHStrongify(self);
        MHStoreShopDetailController *vc = [[MHStoreShopDetailController alloc] initWithmerchant_id:self.viewModel.infoModel.merchant_id];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
}




- (void)openControllerWithType:(MHMineMerchantType)type {
    
    if(type == MHMineMerchantType_orderCost){//订单消费
        MHQRCodeController *qrcodeVC = [[MHQRCodeController alloc] initWithParma:nil CodeType:MHQRCodeType_OrderCo];
        [self.navigationController pushViewController:qrcodeVC animated:YES];
        
    }else if (type == MHMineMerchantType_orderManagement) {  //管理订单
        MHMerchantOrderManagerController *controller = [MHMerchantOrderManagerController new];
        controller.merchant_id = self.viewModel.infoModel.merchant_id ;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (type == MHMineMerchantType_QR) { //收款码
        MHMineColQrCodeController *vc = [MHMineColQrCodeController new];
        vc.merchant_id = self.viewModel.infoModel.merchant_id ;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (type == MHMineMerchantType_reimburse){ //处理退款
        MHMerchantRefundDoingController *controller = [MHMerchantRefundDoingController new];
        controller.merchant_id = self.viewModel.infoModel.merchant_id ;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (type == MHMineMerchantType_financial) { // 财务报表
        
        MHMineMerFinListController * vc = [[MHMineMerFinListController alloc] init];
        vc.merchant_id = self.viewModel.infoModel.merchant_id ;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (type == MHMineMerchantType_collection) { // 扫码收款
        NSMutableDictionary *parma = [NSMutableDictionary dictionary];
        [parma setValue:self.viewModel.infoModel.merchant_id forKey:@"merchant_id"];
        
        MHMineInputFieldController *vc = [[MHMineInputFieldController alloc] initWithInputType:MHMineInputFieldType_ScanQRCol parma:parma];
        [self.navigationController saveDirectViewControllerName:NSStringFromClass([self class])];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (type == MHMineMerchantType_idea){ // 反馈意见
        MHStoreFeedbackViewController *vc = [[MHStoreFeedbackViewController alloc] init];
        vc.type = 1 ;
        vc.merchant_id = [self.viewModel.infoModel.merchant_id integerValue];
        [self hl_setNavigationItemColor:[UIColor whiteColor]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (type == MHMineMerchantType_call){  // 客服电话
        [self showMerchantPhoneSheet];
    }else if(type == MHMineMerchantType_withdrawal){
        [self hl_setNavigationItemColor:[UIColor whiteColor]];
        MHMineMerWithdrawViewController *withDrawVC = [MHMineMerWithdrawViewController new];
        [self.navigationController pushViewController:withDrawVC animated:YES];
    }
}


- (void)showMerchantPhoneSheet {
    [[MHAlertView sharedInstance]
     showTitleActionSheetTitle:@"拨打客服电话" sureHandler:^{
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.viewModel.infoModel.customer_contact_tel]]];
     }
     cancelHandler:nil
     sureButtonColor:MColorBlue
     sureButtonTitle:self.viewModel.infoModel.customer_contact_tel];
}



#pragma mark - SetUI

- (void)setUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MColorBackgroud;
    [self.view addSubview:self.collectionView];
}


- (void)addRightBar {
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Mine_mer_switch"] style:UIBarButtonItemStylePlain target:self action:@selector(switchAccount)];;
}

#pragma mark - Event

- (void)switchAccount {
    if (self.viewModel.infoModel.my_merchant_list.count < 2) {
        return;
    }else {
        NSMutableArray *alertButtons = [NSMutableArray array];
        [self.viewModel.infoModel.my_merchant_list enumerateObjectsUsingBlock:^(MHMineMerchantInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHAlertConfig *button = [[MHAlertConfig alloc]initWithTitle:obj.name image:nil];
            [alertButtons addObject:button];
        }];
        MHAlertSheetView *sheet = [[MHAlertSheetView alloc] initWithTitle:nil buttons:alertButtons comple:^(NSInteger index) {
            MHMineMerchantInfoModel *cModel = self.viewModel.infoModel.my_merchant_list[index];
            [self.viewModel.serverCommand execute:cModel.merchant_id];
        }];
        [sheet show];
    }
}


#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(MScreenW / 3, MScreenW / 3);
        layout.minimumLineSpacing = 0 ;
        layout.minimumInteritemSpacing = 0 ;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical ;
        _collectionView = [MHMineMerchantDelegateModel createCollectionViewWithLayout:layout rigistNibCellNames:@[NSStringFromClass([MHVoSeverPageCell class])] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.frame = self.view.bounds;
    } return _collectionView ;
}

- (MHMineMerchantViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [MHMineMerchantViewModel new];
    }return _viewModel;
}


@end
