//
//  LPasswordSetInputViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordSetInputViewController.h"
#import "LPasswordResetInputView.h"
#import "LSetNewPasswordViewController.h"
#import "LPayPasswordValidate.h"
#import "LFindPasswordViewController.h"

@interface LPasswordSetInputViewController ()

@property (nonatomic,strong)LPasswordResetInputView *ainputView;
@property (nonatomic,strong)LPayPasswordValidate *viewModel;

@end

@implementation LPasswordSetInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    [self bindSignal];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUpUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.ainputView];
    [_ainputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.equalTo(scrollView.mas_left);
        make.right.equalTo(scrollView.mas_right);
        make.bottom.lessThanOrEqualTo(scrollView.mas_bottom);
        make.width.equalTo(scrollView.mas_width);
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)bindSignal{
    @weakify(self);
    [self.viewModel.payPasswordValidateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LSetNewPasswordViewController *passwordVC = [[LSetNewPasswordViewController alloc] initWithSetType:PayPassword_reset];
        [self.navigationController pushViewController:passwordVC animated:YES];
    }];
    [[self.viewModel.payPasswordValidateCommand errors] subscribeNext:^(NSError * error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
}
- (void)passwordInputComple{
    NSString *password = self.ainputView.inputBgView.inputStrig;
    if(password.length == 6){
        [self.viewModel.payPasswordValidateCommand execute:password];
    }
    
}
- (void)forgetPasswordAction{
    LFindPasswordViewController *findPasswordVC = [LFindPasswordViewController new];
    findPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findPasswordVC animated:YES];
    
}

- (LPasswordResetInputView *)ainputView{
    if(!_ainputView){
        _ainputView = [LPasswordResetInputView new];
        @weakify(self);
        [[_ainputView.forgetPasswordSubject throttle:.2] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self forgetPasswordAction];
        }];
        _ainputView.inputBgView.passwordInputCompleBlock = ^{
            @strongify(self);
            [self passwordInputComple];
        };
    }
    return _ainputView;
}

- (LPayPasswordValidate *)viewModel{
    if(!_viewModel){
        _viewModel = [LPayPasswordValidate new];
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
