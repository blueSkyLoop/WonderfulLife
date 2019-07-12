//
//  LFindPasswordViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LFindPasswordViewController.h"
#import "LSetNewPasswordViewController.h"
#import "LFindPasswordView.h"
#import "MHUserInfoManager.h"
#import "LPayPasswordFind.h"

@interface LFindPasswordViewController ()

@property (nonatomic,strong)LFindPasswordView *afindPasswordView;
@property (nonatomic,strong)LPayPasswordFind *viewModel;

@end

@implementation LFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self setConfig];
    
    [self bindSignal];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUpUI{
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.afindPasswordView];
    [_afindPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)setConfig{
    NSString *phoneNum = [MHUserInfoManager sharedManager].phone_number;
    if(phoneNum && phoneNum.length > 4){
        NSRange range = NSMakeRange(0, phoneNum.length - 4);
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[phoneNum substringWithRange:range]];
        [attribute addAttribute:NSKernAttributeName value:@(6) range:range];
        self.afindPasswordView.frontNumLabel.attributedText = attribute;
    }
    
}

- (void)bindSignal{
    @weakify(self);
    [self.afindPasswordView.codeGetSubject subscribeNext:^(NSString *phoneNum) {
        @strongify(self);
        [self.viewModel.codeGetCommand execute:phoneNum];
    }];
    
    [self.viewModel.codeGetCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MHHUDManager showText:@"验证码已发送到您的手机"];
        [self.afindPasswordView createTimer];
    }];
    [[self.viewModel.codeGetCommand errors] subscribeNext:^(NSError *error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
    [self.afindPasswordView.codeValiteSubject subscribeNext:^(NSDictionary *parameter) {
        @strongify(self);
        [self.viewModel.codeValiteCommand execute:parameter];
    }];
    
    [self.viewModel.codeValiteCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LSetNewPasswordViewController *setNewPasswordVC = [[LSetNewPasswordViewController alloc] initWithSetType:PayPassword_reset];
        setNewPasswordVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setNewPasswordVC animated:YES];
    }];
    [[self.viewModel.codeValiteCommand errors] subscribeNext:^(NSError *error) {
        [MHHUDManager showErrorText:error.userInfo[@"errmsg"]];
    }];
    
}

#pragma mark - lazyload
- (LFindPasswordView *)afindPasswordView{
    if(!_afindPasswordView){
        _afindPasswordView = [LFindPasswordView new];
        
    }
    return _afindPasswordView;
}

- (LPayPasswordFind *)viewModel{
    if(!_viewModel){
        _viewModel = [LPayPasswordFind new];
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
