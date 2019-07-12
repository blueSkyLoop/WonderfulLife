//
//  MHPasswordCompleViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHPasswordCompleViewController.h"
#import "UINavigationController+MHDirectPop.h"
#import "LPasswordSuggestAlert.h"
#import "MHIntegralsPayAlertView.h"
#import "LPasswordSetViewController.h"
#import "MHUserInfoManager.h"
#import "UIViewController+PresentLoginController.h"
#import "MHVoDataFillController.h"
#import "UIViewController+MHBackToRoot.h"
#import "LIntegralsPayViewController.h"

@interface MHPasswordCompleViewController ()

@property (nonatomic,assign)MHAlertShowType type;

@end

@implementation MHPasswordCompleViewController

- (id)initWithAlertType:(MHAlertShowType)type{
    self = [super init];
    if(self){
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MRGBColor(132, 139, 148);
    
    [self setUpAlertView];
}

//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Private
- (void)passwordCompleSet{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIViewController *findController = [self.navigationController findDirectViewController];
    if(findController){
        if([findController isKindOfClass:[LPasswordSetViewController class]]){
            LPasswordSetViewController *setVC = (LPasswordSetViewController *)findController;
            setVC.type = PasswordReSet;
        }else if([findController isKindOfClass:[LIntegralsPayViewController class]]){
            LIntegralsPayViewController *setVC = (LIntegralsPayViewController *)findController;
            setVC.showPayAlert = YES;
        }
        [self.navigationController popToViewController:findController animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)backTopHomePage{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self backToHome];
}

- (void)p_checkisLogin {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    BOOL isLogin = [MHUserInfoManager sharedManager].isLogin;
    if (isLogin) {
        MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
        vc.fromIndex = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentLoginControllerWithJoinVolunteer:YES];
    }
}

#pragma mark - 不同类型的弹窗

- (void)setUpAlertView{
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (self.type) {
        case MHAlertShow_passwordComple://支付密码设置成功
        {
            [self setUpPasswordCompleAlertView];
        }
            break;
        case MHAlertShow_passwordFailure://支付密码设置失败
        {
            [self setUpPasswordFailureAlertView];
        }
            break;
        case MHAlertShow_notVolunteer://不是志愿者
        {
            [self setUpNotVolunteerAlertView];
        }
            break;
        case MHAlertShow_integralsLess://积分余额不足
        {
            [self setUpIntegralsLessAlertView];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setUpPasswordCompleAlertView{
    
    LPasswordSuggestAlert *alertView = [[LPasswordSuggestAlert alloc] initWithSuggestComple:^{
        [self passwordCompleSet];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    alertView.backgroundColor = [UIColor clearColor];
    UIViewController *findController;
    for(UIViewController *controller in self.navigationController.viewControllers){
        if([controller isKindOfClass:[LIntegralsPayViewController class]]){
            findController = controller;
            break;
        }
    }
    if(findController){
        [alertView.button setTitle:@"立即支付" forState:UIControlStateNormal];
    }
    alertView.suggestLabel.text = @"设置成功";
    alertView.suggestImageView.image = [UIImage imageNamed:@"ps_set_success"];
    //这里加载到self.view上，所以不要调起show，show是加载到window上
    //[alert show]
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)setUpPasswordFailureAlertView{
    LPasswordSuggestAlert *alertView = [[LPasswordSuggestAlert alloc] initWithSuggestComple:^{
        [self.callBackSubject sendNext:nil];
        [self passwordCompleSet];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.suggestLabel.text = @"设置失败";
    alertView.suggestImageView.image = [UIImage imageNamed:@"ps_failure"];
    [alertView.button setTitle:@"重新设置" forState:UIControlStateNormal];
    //这里加载到self.view上，所以不要调起show，show是加载到window上
    //[alert show]
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)setUpNotVolunteerAlertView{
    
    MHIntegralsPayAlertView *alertView = [[MHIntegralsPayAlertView alloc] initWithPaySuggestType:IntegralsPayFailuret_notVolunteer comple:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){//注册
            [self p_checkisLogin];
            
        }else if(buttonIndex == 1){//我知道了
            [self backTopHomePage];
        }
    }];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.suggestLabel.text = @"您还不是志愿者，不可消费积分\n请先注册成为志愿者";
    //这里加载到self.view上，所以不要调起show，show是加载到window上
//    [alert show];
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)setUpIntegralsLessAlertView{
    MHIntegralsPayAlertView *alertView = [[MHIntegralsPayAlertView alloc] initWithPaySuggestType:IntegralsPayFailuret_less comple:^(NSInteger buttonIndex) {
        [self backTopHomePage];
    }];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.suggestLabel.text = @"积分余额不足无法支付\n请退出选择微信或支付宝支付";
    //这里加载到self.view上，所以不要调起show，show是加载到window上
//    [alert show];
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - lazyload
- (RACSubject *)callBackSubject{
    if(!_callBackSubject){
        _callBackSubject = [RACSubject subject];
    }
    return _callBackSubject;
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
