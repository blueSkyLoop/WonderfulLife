//
//  MHStoreOrdersConsumptionViewInputController.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrdersConsumptionViewInputController.h"
#import "MHMerchantOrderDetailController.h"

#import "MHThemeButton.h"
#import "LCommonModel.h"
#import "MHStoreOrdersConsumptionView.h"
#import "MHNavigationControllerManager.h"
#import "MHStoreOrdersConsumptionViewModel.h"
#import "UIViewController+PresentLoginController.h"

@interface MHStoreOrdersConsumptionViewInputController ()<MHNavigationControllerManagerProtocol,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet MHThemeButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottom;
@property (nonatomic,strong)MHStoreOrdersConsumptionView *ordersConsumptionView;
@property (nonatomic,copy)NSString *errorOrderNo;

@property (nonatomic,strong)MHStoreOrdersConsumptionViewModel *viewModel;

@end

@implementation MHStoreOrdersConsumptionViewInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.order_no = _infor[@"order_no"];
    self.textF.text = _infor[@"order_no"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.infor){
            [self showOrderAlertView];
            [self.ordersConsumptionView configWithDict:self.infor];
        }
    });
    
}


- (void)setInfor:(NSDictionary *)infor{
    if(_infor != infor){
        _infor = infor;
        self.viewModel.order_no = _infor[@"order_no"];
        self.textF.text = _infor[@"order_no"];
    }
}

- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)mh_setUpUI{
    UIFont *afont;
    if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
        afont = [UIFont systemFontOfSize:MScale * 32 weight:UIFontWeightSemibold];
    }else{
        afont = [UIFont systemFontOfSize:MScale * 32];
    }
    self.titleLabel.font = afont;
    self.textF.font = [UIFont systemFontOfSize:MScale * 17];
    self.textF.delegate = self;
    self.sureBtn.layer.cornerRadius = 2;
    self.sureBtn.layer.masksToBounds = YES;
    
}

- (void)mh_bindViewModel{
    
    @weakify(self);
    [[self.textF rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        if(text && text.length){
            self.sureBtn.enabled = YES;
        }else{
            self.sureBtn.enabled = NO;
        }
        if (text.length > 20) {
            self.textF.text = [text substringToIndex:20];
        }
        if(self.errorOrderNo && [text isEqualToString:self.errorOrderNo]){
            self.textF.textColor = MRGBColor(255, 73, 73);
            self.sureBtn.enabled = NO;
            [MHHUDManager showErrorText:@"订单不存在"];
        }else{
            self.textF.textColor = MRGBColor(50, 64, 87);
            self.sureBtn.enabled = YES;
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        CGRect beginRect = [x.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endRect = [x.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        BOOL b = beginRect.origin.y > endRect.origin.y;
        @strongify(self);
        if (b) { //显示
            self.buttonBottom.constant += 216;
        }else{ //隐藏
            self.buttonBottom.constant -= 216;
        }
    }];
    
    RAC(self.viewModel,order_no) = self.textF.rac_textSignal;
    
    [self.viewModel.orderDetailCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *x) {
        @strongify(self);
        [self showOrderAlertView];
        self.infor = x;
        [self.ordersConsumptionView configWithDict:x];
    }];
    [[self.viewModel.orderDetailCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if ([error.userInfo[@"errmsg"] isEqualToString:@"订单不存在"]) {
            self.textF.textColor = MRGBColor(255, 73, 73);
        }
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
    [self.viewModel.orderCostCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *x) {
        @strongify(self);
        MHMerchantOrderDetailController *vc = [MHMerchantOrderDetailController new];
        vc.order_no = self.viewModel.order_no;
        vc.controlType = MHMerchantOrderDetailControlTypeMerchant;
        [self.navigationController pushViewController:vc animated:YES];
        [self closeAlertView];
    }];
    [[self.viewModel.orderCostCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureAction:(MHThemeButton *)sender {
    [self.view endEditing:YES];
    //查询订单详情
    [self.viewModel.orderDetailCommand execute:nil];
}

- (void)handleOrderWithIndex:(NSInteger)index{
   
    switch (index) {
        case 1://查看详情
        {
            MHMerchantOrderDetailController *vc = [MHMerchantOrderDetailController new];
            vc.controlType = MHMerchantOrderDetailControlTypeMerchant;
            vc.order_no = self.viewModel.order_no;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://取消
        {
             [self closeAlertView];
            
        }
            break;
        case 3://确定
        {
            NSInteger type = [self.ordersConsumptionView.inforDict[@"order_status_type"] integerValue];
            if (type == 1 || type == 6) {
                 [self.viewModel.orderCostCommand execute:nil];
            }else{
                [self closeAlertView];
            }
           
        }
            break;
            
        default:
            break;
    }
}
- (void)showOrderAlertView{
    [self closeAlertView];
    [self.view addSubview:self.ordersConsumptionView];
    [_ordersConsumptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)closeAlertView{
    if(_ordersConsumptionView && _ordersConsumptionView.superview){
        [_ordersConsumptionView removeFromSuperview];
    }
    _ordersConsumptionView = nil;
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textColor = MColorTitle;
    return YES;
}

#pragma mark - lazy load
- (MHStoreOrdersConsumptionView *)ordersConsumptionView{
    if(!_ordersConsumptionView){
        _ordersConsumptionView = [MHStoreOrdersConsumptionView loadViewFromXib];
        @weakify(self);
        _ordersConsumptionView.buttonClikBlock = ^(NSInteger index){
            @strongify(self);
            [self handleOrderWithIndex:index];
        };
    }
    return _ordersConsumptionView;
}

- (MHStoreOrdersConsumptionViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreOrdersConsumptionViewModel new];
    }
    return _viewModel;
}

@end
