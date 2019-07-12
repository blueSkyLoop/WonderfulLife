//
//  LSetNewPasswordViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LSetNewPasswordViewController.h"
#import "LPasswordSetNewView.h"
#import "LPayPasswordSet.h"
#import "MHHUDManager.h"
#import "MHThemeButton.h"
#import "LPasswordSuggestAlert.h"
#import "LPasswordSetViewController.h"
#import "MHUserInfoManager.h"
#import "UINavigationController+MHDirectPop.h"
#import "MHPasswordCompleViewController.h"

@interface LSetNewPasswordViewController ()

@property (nonatomic,strong)LPasswordSetNewView *passwordView;
@property (nonatomic,strong)MHThemeButton *sureBtn;
@property (nonatomic,strong)LPayPasswordSet *viewModel;


@property (nonatomic,assign)BOOL setSuccessFlag;


@end

@implementation LSetNewPasswordViewController

- (id)initWithSetType:(PayPasswordSetType)asetNewPassword{
    self = [super init];
    if(self){
        self.setNewPasswordType = asetNewPassword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self bindSignal];
    
    [self setConfig];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return !self.setSuccessFlag;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.setSuccessFlag){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self passwordCompleSet];
        });
    }
}

- (void)setUpUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    UIView *bgView = [UIView new];
    [self.view addSubview:scrollView];
    [scrollView addSubview:bgView];
    [bgView addSubview:self.passwordView];
    [bgView addSubview:self.sureBtn];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_passwordView.mas_bottom).offset(24);
        make.left.equalTo(bgView.mas_left).offset(32);
        make.right.equalTo(bgView.mas_right).offset(-24);
        make.bottom.equalTo(bgView.mas_bottom).offset(-20).priorityHigh();
        make.height.equalTo(@56);
    }];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight)).priorityHigh();
        make.width.equalTo(scrollView.mas_width);
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)setConfig{
  
    self.passwordView.atitleLable.text = self.setNewPasswordType == PayPassword_reset?@"设置新密码":@"设置密码";
    [self.passwordView.inputBgView updataTitleNameWith:self.setNewPasswordType == PayPassword_reset?@"输入新支付密码":@"输入支付密码"];
    [self.passwordView.reInputBgView updataTitleNameWith:self.setNewPasswordType == PayPassword_reset?@"重复新支付密码":@"重复支付密码"];
    
    
}

- (void)bindSignal{
    
    RACSignal *orPassword = RACObserve(self.passwordView.inputBgView, inputStrig);
    RACSignal *rePassword = RACObserve(self.passwordView.reInputBgView, inputStrig);
    RACSignal *reduce = [RACSignal combineLatest:@[orPassword,rePassword] reduce:^id(NSString *orPasswordText,NSString *rePasswordText){
        return @(orPasswordText.length == 6 && rePasswordText.length == 6 && [orPasswordText isEqualToString:rePasswordText]);
    }];
    
    RAC(self.sureBtn,enabled) = reduce;
    
    RACSignal *reduce1 = [RACSignal combineLatest:@[orPassword,rePassword] reduce:^id(NSString *orPasswordText,NSString *rePasswordText){
        return @(orPasswordText.length == 6 && rePasswordText.length == 6 && ![orPasswordText isEqualToString:rePasswordText]);
    }];
    [reduce1 subscribeNext:^(NSNumber *x) {
        if(x.boolValue){
            [MHHUDManager showErrorText:@"密码确认错误，请重设"];
        }
    }];
    
}

- (void)passwordCompleSet{
    
    UIViewController *findController = [self.navigationController findDirectViewController];
    if(findController){
        if([findController isKindOfClass:[LPasswordSetViewController class]]){
            LPasswordSetViewController *setVC = (LPasswordSetViewController *)findController;
            setVC.type = PasswordReSet;
        }
         [self.navigationController popToViewController:findController animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)payPasswordSetRequest{
    
    NSString *password = self.passwordView.inputBgView.inputStrig;
    if(password.length == 6){
        @weakify(self);
        [[self.viewModel.payPasswordCommand execute:password] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            self.setSuccessFlag = NO;
            self.setSuccessFlag = YES;
            [MHUserInfoManager sharedManager].is_set_pay_password = @1;
            [[MHUserInfoManager sharedManager] saveUserInfoData];
            MHPasswordCompleViewController *vc = [[MHPasswordCompleViewController alloc] initWithAlertType:MHAlertShow_passwordComple];
            vc.view.frame = CGRectMake(0, 0, MScreenW, MScreenH);
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [[self.viewModel.payPasswordCommand errors] subscribeNext:^(NSError * error) {
            @strongify(self);
            self.setSuccessFlag = NO;
            MHPasswordCompleViewController *vc = [[MHPasswordCompleViewController alloc] initWithAlertType:MHAlertShow_passwordFailure];
            [[vc.callBackSubject throttle:0.2] subscribeNext:^(id  _Nullable x) {
                [self.passwordView clearAllInput];
                self.sureBtn.enabled = NO;
            }];
            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
            vc.view.frame = CGRectMake(0, 0, MScreenW, MScreenH);
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
//            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark - lazyload
- (LPasswordSetNewView *)passwordView{
    if(!_passwordView){
        _passwordView = [LPasswordSetNewView new];
       
    }
    return _passwordView;
}

- (MHThemeButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 16];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 18];
        @weakify(self);
        [[_sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self payPasswordSetRequest];
            
        }];
    }
    return _sureBtn;
}
- (LPayPasswordSet *)viewModel{
    if(!_viewModel){
        _viewModel = [LPayPasswordSet new];
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
