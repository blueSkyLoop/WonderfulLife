//
//  LPasswordSetViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordSetViewController.h"
#import "LPasswordSetInputViewController.h"
#import "LSetNewPasswordViewController.h"
#import "UINavigationController+MHDirectPop.h"
#import "MHPasswordResetView.h"
#import "MHPasswordUnsetView.h"

@interface LPasswordSetViewController ()

@property (nonatomic,strong)MHPasswordUnsetView *unSetPasswordView;
@property (nonatomic,strong)MHPasswordResetView *reSetPasswordView;

@end

@implementation LPasswordSetViewController

- (id)initWithPasswordSetType:(PasswordSetType)type{
    self = [super init];
    if(self){
        
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码设置";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
}


- (void)setType:(PasswordSetType)type{
    _type = type;
    if(_type == PasswordReSet){
        if(_unSetPasswordView){
            [_unSetPasswordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_unSetPasswordView removeFromSuperview];
            _unSetPasswordView = nil;
        }
        [self setUpResetPasswordUI];
    }else{
        if(_reSetPasswordView){
            [_reSetPasswordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_reSetPasswordView removeFromSuperview];
            _reSetPasswordView = nil;
        }
        [self setUpPasswordSetUI];
    }
}
//设置
- (void)setUpPasswordSetUI{
    
    if(_unSetPasswordView && _unSetPasswordView.superview)  {
        [_unSetPasswordView removeFromSuperview];
    };
    _unSetPasswordView = nil;
    
    self.view.backgroundColor = MRGBColor(249, 250, 252);
    
    [self.view addSubview:self.unSetPasswordView];
    
    [_unSetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(32);
        make.right.equalTo(self.view.mas_right).offset(-24);
    }];
    
    @weakify(self);
    [[self.unSetPasswordView.passwordSetSubject throttle:.2] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LSetNewPasswordViewController *newPasswordVC = [[LSetNewPasswordViewController alloc] initWithSetType:PayPassword_set];;
        newPasswordVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
        [self.navigationController pushViewController:newPasswordVC animated:YES];
    }];
    
}

//重置
- (void)setUpResetPasswordUI{

    if(_reSetPasswordView && _reSetPasswordView.superview)  {
        [_reSetPasswordView removeFromSuperview];
    };
    _reSetPasswordView = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.reSetPasswordView];
    
    [_reSetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@80);
    }];
    @weakify(self);
    [[self.reSetPasswordView.passwordResetSubject throttle:.2] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LPasswordSetInputViewController *inputVC = [LPasswordSetInputViewController new];
        inputVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
        [self.navigationController pushViewController:inputVC animated:YES];
    }];
    
}


#pragma mark - lazyload
- (MHPasswordResetView *)reSetPasswordView{
    if(!_reSetPasswordView){
        _reSetPasswordView = [MHPasswordResetView new];
    }
    return _reSetPasswordView;
}

- (MHPasswordUnsetView *)unSetPasswordView{
    if(!_unSetPasswordView){
        _unSetPasswordView = [MHPasswordUnsetView new];
    }
    return _unSetPasswordView;
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
