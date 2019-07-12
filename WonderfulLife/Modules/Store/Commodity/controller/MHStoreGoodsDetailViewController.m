//
//  MHStoreGoodsDetailViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailViewController.h"

#import "JFAuthorizationStatusManager.h"
#import "JFMapManager.h"
#import "MHConst.h"

#import "MHStoreGoodsDetailDelegateModel.h"
#import "MHStoreGoodsDetailViewModel.h"

#import "MHStorePictureCell.h"
#import "MHStoreGoodsDetailInforCell.h"
#import "MHStoreGoodsDetailBottomView.h"

#import "MHStoreOrderSubmitViewController.h"
#import "MHStoreShopDetailController.h"
#import "MHReportRepairPhotoPreViewController.h"

@interface MHStoreGoodsDetailViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MHStoreGoodsDetailViewModel *viewModel;
@property (nonatomic,strong)MHStoreGoodsDetailDelegateModel *delegateModel;
@property (nonatomic,strong)MHStoreGoodsDetailBottomView *bottomView;

//是否需要等待定位完成之后调接口
@property (nonatomic,assign)BOOL needWaitForLocation;

@property (nonatomic,assign)BOOL refreshFlag;

@end

@implementation MHStoreGoodsDetailViewController

- (id)initWithCoupon_id:(NSInteger)coupon_id{
    self = [super init];
    if(self){
        self.coupon_id = coupon_id;
    }
    return self;
}

- (void)setCoupon_id:(NSInteger)coupon_id{
    if(_coupon_id != coupon_id){
        _coupon_id = coupon_id;
        self.viewModel.coupon_id = _coupon_id;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        if(!self.viewModel.listRequesting){
            [self.viewModel.goodsDetailCommand execute:nil];
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
    
    if(!self.needWaitForLocation){
        if(!self.viewModel.listRequesting){
            [self.viewModel.goodsDetailCommand execute:nil];
        }
    }else{
        [self startLocation];
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
                if(self.needWaitForLocation ){
                    if(!self.viewModel.listRequesting){
                        self.viewModel.current_gps_lat = location.coordinate.latitude;
                        self.viewModel.current_gps_lng = location.coordinate.longitude;
                        [self.viewModel.goodsDetailCommand execute:nil];
                    }
                }
                self.needWaitForLocation = NO;
                
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
    
    if(self.refreshFlag){
        [self.viewModel.goodsDetailCommand execute:nil];
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
                if(coupon_id == self.viewModel.coupon_id){
                    [self.viewModel.goodsDetailCommand execute:nil];
                }
            }else{
                //记录一下，待出现这个界面时刷新数据
                NSInteger coupon_id = [x.object integerValue];
                if(coupon_id == 0) return ;
                if(coupon_id == self.viewModel.coupon_id){
                    self.refreshFlag = YES;
                }
            }
        });
        
    }];
    
}

- (void)mh_setUpUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@60);
    }];
}

- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.goodsDetailCommand.executionSignals.switchToLatest subscribeNext:^(MHStoreGoodsDetailModel *model) {
        @strongify(self);
        self.refreshFlag = NO;
        self.delegateModel.detailModel = model;
        [self.tableView reloadData];
        if(model.top_title && model.top_title.length){
            self.title = model.top_title;
        }else{
            self.title = @"商品详情";
        }
        [self.bottomView configBottomViewWithModel:model];
    }];
    [[self.viewModel.goodsDetailCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    
    self.delegateModel = [[MHStoreGoodsDetailDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure tableView:self.tableView cellClassNames:@[NSStringFromClass(MHStorePictureCell.class),NSStringFromClass(MHStoreGoodsDetailInforCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        
    }];
    //点击商家
    self.delegateModel.merchantClikBlock = ^{
        @strongify(self);
        MHStoreShopDetailController *merchantVC = [MHStoreShopDetailController new];
        merchantVC.merchant_id = @(self.viewModel.goodsDetailModel.merchant_id);
        [self.navigationController pushViewController:merchantVC animated:YES];
    };
    //封面图点击看大图
    self.delegateModel.coverPicClikBlock = ^{
        @strongify(self);
        MHReportRepairPhotoPreViewController *photoVC = [MHReportRepairPhotoPreViewController new];
        MHReportRepairPhotoPreViewModel *model = [MHReportRepairPhotoPreViewModel new];
        model.bigPicUrl = self.viewModel.goodsDetailModel.img_cover.url?:self.viewModel.goodsDetailModel.img_cover.s_url;
        model.type = 1;
        photoVC.dataArr = [@[model] mutableCopy];
        [self.navigationController pushViewController:photoVC animated:YES];
    };
    
    //购买按钮点击事件
    [[[self.bottomView.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.viewModel.goodsDetailModel.status == 1){
            [MHHUDManager showText:@"商城已关闭，无法购买商品"];
            return ;
        }
        MHStoreOrderSubmitViewController *submitVc = [[MHStoreOrderSubmitViewController alloc] initWithGoodsDetailModel:self.viewModel.goodsDetailModel];
        [self.navigationController pushViewController:submitVc animated:YES];
    }];
    
    
}


#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHStoreGoodsDetailDelegateModel createTableWithStyle:UITableViewStyleGrouped rigistNibCellNames:@[NSStringFromClass(MHStorePictureCell.class),NSStringFromClass(MHStoreGoodsDetailInforCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = MColorBackgroud;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MScreenW, 0.001)];
        headView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headView;
    }
    return _tableView;
}
- (MHStoreGoodsDetailBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [MHStoreGoodsDetailBottomView new];
    }
    return _bottomView;
}
- (MHStoreGoodsDetailViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreGoodsDetailViewModel new];
    }
    return _viewModel;
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
