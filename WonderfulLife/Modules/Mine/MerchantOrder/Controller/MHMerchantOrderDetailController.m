//
//  MHMerchantOrderDetailController.m
//  WonderfulLife
//
//  Created by zz on 25/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailController.h"
#import "MHMerchantOrderqrCodeController.h"
#import "MHStoreShopDetailController.h"
#import "MHStoreRefundViewController.h"
#import "MHStoreFeedbackViewController.h"
#import "MHStoreGoodsDetailViewController.h"
#import "MHHomePayChooseController.h"

//Cell
#import "MHMerchantOrderDetailCell.h"
#import "MHMerchantOrderDetailStatusRefundCell.h"
#import "MHMerchantOrderDetailReviewsCell.h"
#import "MHMerchantOrderDetailStatusNormalCell.h"
#import "MHMerchantOrderDetailStatusVendorCell.h"
#import "MHMerchantOrderDetailReviewsPicturesCell.h"

//HeaderView Or FooterView
#import "MHMerchantOrderDetailGoodsView.h"
#import "MHMerchantOrderDetailBottomButtonView.h"

#import "MHAlertView.h"

#import "MHMerchantOrderDetailModel.h"
#import "MHStoreGoodPayModel.h"
#import "MHStoreGoodsHandler.h"

#import "Masonry.h"
#import "MHMacros.h"
#import "UITableViewCell_MHMerchantOrder.h"

#import "MHHUDManager.h"
#import "JFMapManager.h"
#import "MHHUDManager.h"
#import "JFAuthorizationStatusManager.h"


@interface MHMerchantOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,MHMerchantOrderDetailBottomButtonDelegate,MHMerchantOrderDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MHMerchantOrderDetailViewModel *viewModel;
@property (strong, nonatomic) MHMerchantOrderDetailBottomButtonView *footerView;
@property (strong, nonatomic) UIButton *qrCodeButton;

@property (assign, nonatomic) BOOL needWaitForLocation;
@end

@implementation MHMerchantOrderDetailController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:@"merchantOrderDetail_QR"] forState:UIControlStateNormal];
    [confirm sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(pushToQrViewController) forControlEvents:UIControlEventTouchUpInside];
    self.qrCodeButton = confirm;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    if (self.controlType == MHMerchantOrderDetailControlTypeCustomer) {
        [self requestDetailData];
    }else {
        [self requestMerchantDetailData];
    }
    
    self.tableView.hidden = YES;
    
    self.needWaitForLocation = YES;
    
    [self verifyLocationEnable];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delayExecute];
    });
    
    RACSignal *notification = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kStoreRefundSuccessNotification" object:nil] takeUntil:self.rac_willDeallocSignal];
    @weakify(self)
    [[notification deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.controlType == MHMerchantOrderDetailControlTypeCustomer) {
            [self.viewModel.pullDetailCommand execute:self.order_no];
        }else {
            [self.viewModel.pullMerchantDetailCommand execute:self.order_no];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startLocation];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : MColorTitle}];
}

- (void)requestDetailData {
    @weakify(self)
    [[self.viewModel.pullDetailCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        RACTupleUnpack(NSNumber *issuccess,id data) = x;

        [MHHUDManager dismiss];
        if (![issuccess boolValue]) {
            [MHHUDManager showErrorText:data];
        }else {// 成功
            self.viewModel.model = data;
            self.viewModel.type = [self.viewModel.model.order_status_type integerValue];
            [self.viewModel bindRegisterCells];
            
            [self registerNib];
            [self registerTableFooterView];
        }
    }];
}

- (void)requestMerchantDetailData {
    @weakify(self)
    [[self.viewModel.pullMerchantDetailCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        RACTupleUnpack(NSNumber *issuccess,id data) = x;
        [MHHUDManager dismiss];
        if (![issuccess boolValue]) {
            [MHHUDManager showErrorText:data];
        }else {// 成功
            self.viewModel.isMerchant = YES;
            self.viewModel.model = data;
            self.viewModel.type = [self.viewModel.model.order_status_type integerValue];
            if (self.controlType == MHMerchantOrderDetailControlTypeMerchant) {
                [self.viewModel bindRegisterMerchantDetailCells];
            }else if (self.controlType == MHMerchantOrderDetailControlTypeRefund) {
                [self.viewModel bindRegisterMerchantDetailCells];
            }
            
            [self registerNib];
            [self registerTableFooterView];
        }
    }];
}


- (void)registerNib{

    self.tableView.hidden = NO;
    
    for (NSArray *classArray in self.viewModel.nibCellNames) {
        for(NSString *className in classArray){
            [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
        }
    }
    
    for (NSArray *classArray in self.viewModel.classCellNames) {
        for(NSString *className in classArray){
            [self.tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
        }
    }

    for(NSString *className in self.viewModel.classHeaderFooterViewNames){
        [self.tableView registerClass:NSClassFromString(className) forHeaderFooterViewReuseIdentifier:className];
    }
    [self.tableView reloadData];
}


- (void)registerTableFooterView {
    self.tableView.tableFooterView = nil;
    [self.footerView removeFromSuperview];
    
    if (self.controlType == MHMerchantOrderDetailControlTypeMerchant) {
        return;
    }
    
    if (self.controlType == MHMerchantOrderDetailControlTypeRefund) {
        if (self.viewModel.type == MHMerchantOrderDetailTypeRefunding) {
            MHMerchantOrderDetailBottomButtonView *footerView = [MHMerchantOrderDetailBottomButtonView new];
            footerView.type = MHMerchantOrderBottomButtonTypeChecking;
            footerView.delegate = self;
            [self.view addSubview:footerView];
            self.footerView = footerView;
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-60);
                make.left.right.top.mas_equalTo(0);
            }];
        }else {
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) { make.edges.mas_equalTo(0);}];
        }
        return;
    }
    
    if (self.viewModel.type == MHMerchantOrderDetailTypeUnReviews||
        self.viewModel.type == MHMerchantOrderDetailTypeRefusedAndUnUsed||
        self.viewModel.type == MHMerchantOrderDetailTypeUnUsed||
        self.viewModel.type == MHMerchantOrderDetailTypeUnPaid) {
        
        MHMerchantOrderDetailBottomButtonView *footerView = [MHMerchantOrderDetailBottomButtonView new];
        if (self.viewModel.type == MHMerchantOrderDetailTypeUnPaid) {
            self.qrCodeButton.hidden = YES;
            footerView.type = MHMerchantOrderBottomButtonTypeUnpaid;
        }else if (self.viewModel.type == MHMerchantOrderDetailTypeUnUsed) {
            footerView.type = MHMerchantOrderBottomButtonTypeUnused;
        }else if (self.viewModel.type == MHMerchantOrderDetailTypeRefusedAndUnUsed){
            footerView.type = MHMerchantOrderBottomButtonTypeRefund;
        }else if (self.viewModel.type == MHMerchantOrderDetailTypeUnReviews) {
            footerView.type = MHMerchantOrderBottomButtonTypeReviews;
            RACSignal *goodsSignal = [RACObserve(self.viewModel, goodsLevels) filter:^BOOL(id  _Nullable value) {
                if ([value integerValue] > 0) { return YES; }
                return NO;
            }];
            RACSignal *merchantSignal = [RACObserve(self.viewModel, merchantLevels) filter:^BOOL(id  _Nullable value) {
                if ([value integerValue] > 0) {  return YES; }
                return NO;
            }];
            [[goodsSignal concat:merchantSignal] subscribeNext:^(id  _Nullable x) {
                footerView.themeButton.enabled = YES;
            }];
        }
        
        footerView.delegate = self;
        self.tableView.tableFooterView = footerView;
    }
}

#pragma mark - MHMerchantOrderDetailBottomButtonDelegate
- (void)MerchantOrderDetailBottomButtonType:(MHMerchantOrderBottomButtonType)type leftButtonClick:(BOOL)leftClicked rightButtonClick:(BOOL)rightClicked {
   
    if ((self.controlType == MHMerchantOrderDetailControlTypeRefund)) {
        if (leftClicked) {
            MHStoreFeedbackViewController *controller = [MHStoreFeedbackViewController new];
            controller.refund_id = [self.viewModel.model.refund_id integerValue];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (rightClicked) {
            @weakify(self)
            [MHHUDManager show];
            [self.viewModel.postComfirmRefundCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                RACTupleUnpack(NSNumber *issuccess,id data) = x;
                
                if (![issuccess boolValue]) {
                    [MHHUDManager dismiss];
                    [MHHUDManager showErrorText:data];
                }else {// 成功
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"com.MH.kMerchantRefundSuccessNotification" object:nil];
                    [self.viewModel.pullMerchantDetailCommand execute:self.order_no];
                }
            }];
            
            [self.viewModel.postComfirmRefundCommand execute:self.viewModel.model.refund_id];
        }
        return;
    }

    
    if (self.viewModel.type == MHMerchantOrderDetailTypeUnPaid) { //立即支付
        if ([self.viewModel.model.status isEqualToString:@"0"]) {
            [self pushPaidController];
        }else {
            [MHHUDManager showErrorText:@"商城已关闭，无法购买商品"];
        }
    }else if (self.viewModel.type == MHMerchantOrderDetailTypeUnUsed) {//待使用
        if (leftClicked) {
            [self pushRefundController];
        }
    }else if (self.viewModel.type == MHMerchantOrderDetailTypeRefusedAndUnUsed){//已拒绝，待使用
        if (leftClicked) {
            [self pushRefundController];
        }
        if (rightClicked) {
            [self showMerchantPhoneSheet];
        }
    }else if (self.viewModel.type == MHMerchantOrderDetailTypeUnReviews) {//待评价
        [self bindReviewsSignal];
    }
}

- (void)pushPaidController {
    MHStoreGoodPayModel *model = [MHStoreGoodPayModel new];
    model.type = mhPay_coupon_pay;
    model.totalScore = self.viewModel.model.pay_amount;
    model.payTypeStr = @"coupon-order";
    model.payData = self.viewModel.model.order_no;
    model.noticeObject = @"MHMerchantOrderDetailController";
    MHHomePayChooseController *controller = [[MHHomePayChooseController alloc] initWithPayModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushRefundController {
    MHStoreRefundViewController *controller = [MHStoreRefundViewController new];
    controller.orderDetailModel = self.viewModel.model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showMerchantPhoneSheet {
    [[MHAlertView sharedInstance]
     showTitleActionSheetTitle:@"拨打客服电话" sureHandler:^{
         NSString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel://%@",self.viewModel.model.merchant_phone];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
     }
     cancelHandler:nil
     sureButtonColor:MColorBlue
     sureButtonTitle:self.viewModel.model.merchant_phone];
}

- (void)bindReviewsSignal {
    @weakify(self)
    [self.viewModel.postReviewsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *issuccess,id data) = x;
        
        if (![issuccess boolValue]) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:data];
        }else {// 成功
            [MHHUDManager dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self.viewModel submitGoodsReviewsInfo];
}

#pragma mark - Public Method
- (void)pushToQrViewController {
    MHMerchantOrderqrCodeController *controller = [MHMerchantOrderqrCodeController new];
    controller.qrcodeUrl = self.viewModel.model.qr_code;
    controller.order_no = self.viewModel.model.order_no;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *classArray = self.viewModel.nibCellNames[section];
    return classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *className = self.viewModel.nibCellNames[indexPath.section][indexPath.row];
    UITableViewCell<MHCellConfigDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:className];
    [cell mh_configCellWithInfor:self.viewModel.model];
    cell.delegate = self;
    return cell;
}

#pragma mark - MHMerchantOrderDelegate

- (void)mh_touchedMerchantShopName:(id)merchantID {
    MHStoreShopDetailController *controller = [MHStoreShopDetailController new];
    controller.merchant_id = merchantID;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mh_touchedMerchantReviewLevelStars:(id)level {
    self.viewModel.merchantLevels = [level integerValue];
}

- (void)mh_touchedGoodsReviewLevelStars:(id)level; {
    self.viewModel.goodsLevels = [level integerValue];
}

- (void)mh_touchedReviewContent:(id)content {
    self.viewModel.reviewsContent = content;
}

- (void)mh_touchedReviewPictures:(NSArray *)pictures asserts:(NSArray *)asserts{
    self.viewModel.model.selectedImages = pictures;
    self.viewModel.model.selectedAsserts = asserts;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mh_touchedGoodsBaseView:(id)goodID {
    if ([goodID integerValue] != 0) {//2018.1.9 新增商品ID为0的时候，不跳商品详情页面...
        MHStoreGoodsDetailViewController *controller = [[MHStoreGoodsDetailViewController alloc]init];
        controller.coupon_id = [goodID integerValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {  return nil; }
    MHMerchantOrderDetailGoodsView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MHMerchantOrderDetailGoodsView"];
    headerView.delegate = self;
    [headerView mh_configCellWithInfor:self.viewModel.model];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==0?18.f:0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01f:140.f;
}

#pragma mark - Location


//延迟后（定位超时）判断
- (void)delayExecute{
    //超时都没有定位成功，也要请求数据了
    if(self.needWaitForLocation){
        [MHHUDManager dismiss];
        self.needWaitForLocation = NO;
        [MHHUDManager show];
        if (self.controlType == MHMerchantOrderDetailControlTypeCustomer) {
            [self.viewModel.pullDetailCommand execute:self.order_no];
        }else {
            [self.viewModel.pullMerchantDetailCommand execute:self.order_no];
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
        self.needWaitForLocation = NO;
    }
    
    if(!self.needWaitForLocation){
        [MHHUDManager show];
        if (self.controlType == MHMerchantOrderDetailControlTypeCustomer) {
            [self.viewModel.pullDetailCommand execute:self.order_no];
        }else {
            [self.viewModel.pullMerchantDetailCommand execute:self.order_no];
        }
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
                
                if(self.needWaitForLocation){
                    [MHHUDManager show];
                    if (self.controlType == MHMerchantOrderDetailControlTypeCustomer) {
                        [self.viewModel.pullDetailCommand execute:self.order_no];
                    }else {
                        [self.viewModel.pullMerchantDetailCommand execute:self.order_no];
                    }
                }
                self.needWaitForLocation = NO;
            }
        }];
    }
}


#pragma mark - Getter 
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = MColorBackgroud;
    }
    return _tableView;
}

- (MHMerchantOrderDetailViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [MHMerchantOrderDetailViewModel new];
    }
    return _viewModel;
}

@end
