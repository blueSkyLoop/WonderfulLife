//
//  WHLoginController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLoginController.h"
#import "MHLoSetPlotController.h"
#import "MHTabBarControllerManager+StoreSwitch.h"
#import "HLWebViewController.h"

#import "MHStoreController.h"

#import "UIViewController+HLStoryBoard.h"
#import "UIView+GradientColor.h"
#import "NSString+ValidatePhoneNumber.h"
#import "UIImage+Color.h"

#import "MHValidateCodeButton.h"
#import "MHThemeButton.h"

#import "MHHUDManager.h"
#import "MHMacros.h"
#import "MHConst.h"
#import "MHConstSDKConfig.h"

#import "MHJPushRequestHandle.h"
#import "MHLoginRequestHandler.h"
#import "MHLoSetPlotController.h"
#import "MHMineController.h"
#import "NSObject+CurrentController.h"

#import "YYText.h"
#import <Masonry.h>
#import "UIViewController+MHRootNavigation.h"
#import "MHUserInfoManager.h"
#import "MHStoreGoodsHandler.h"
@interface MHLoginController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet MHValidateCodeButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet MHThemeButton *loginBtn;

@property (nonatomic, strong) YYLabel *footnoteLab;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation MHLoginController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
    [self setupControls];
    [self addControls];
    [self addObservers];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.backBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.backBtn removeFromSuperview];
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   }


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupConfig {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage mh_imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

- (void)setupControls {
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.boxView.layer.borderColor = MColorSeparator.CGColor;
    self.boxView.layer.borderWidth = 1;
    
   
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    
    [self.loginBtn addTarget:self
                        action:@selector(loginAction)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.phoneTf setValue:MColorContent forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTf setValue:MColorContent forKeyPath:@"_placeholderLabel.textColor"];
    __weak __typeof(self)weakSelf = self;
    [self.getCodeBtn setClickBlock:^BOOL{
        __strong __typeof(self)strongSelf = weakSelf;
        
        if (![NSString mh_isMobileNumber:strongSelf.phoneTf.text] && !MH_BUNDLEID_JFKH) {
            [MHHUDManager showText:@"手机号码格式有误"];
            return NO;
        }
        //request
        [strongSelf requestGetVaildateCode];
       
        return YES;
    }];
    
    //显示已登录过帐号
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:kAccount];
    if (account) {
        self.phoneTf.text = account;
        self.getCodeBtn.enabled = YES;
    }
}

- (void)addControls {
    [self.view addSubview:self.footnoteLab];
    [self.footnoteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn);
        make.right.equalTo(self.loginBtn);
        make.top.equalTo(self.loginBtn.mas_bottom).mas_offset(16);
        make.height.mas_equalTo(35);
    }];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeinAPP) name:kComeinAPPNotification object:nil];
}
#pragma mark - Request
/** 
 获取验证码
 */
- (void)requestGetVaildateCode {
    if (!MH_BUNDLEID_JFKH) {
        [MHLoginRequestHandler requestGetVaildateCodeWithPhone:self.phoneTf.text success:^{
            [MHHUDManager showText:@"验证码已发送到您的手机"];
        } failure:^(NSString *errmsg){
            [MHHUDManager showErrorText:errmsg];
        }];
    }
    else{
        [self.codeTf becomeFirstResponder];
         self.codeTf.text = @"8888";
    }
}


/** 
 登录
 */
- (void)reuqestLogin {
    [self.codeTf resignFirstResponder];
    NSString *phone = [MHUserInfoManager sharedManager].phone_number;
    BOOL isSame = NO;
    if([phone isEqualToString:self.phoneTf.text]){
        isSame = YES;
    }

    [MHHUDManager show];
    [MHLoginRequestHandler postPhone:self.phoneTf.text code:self.codeTf.text success:^(BOOL is_user_exist){
        [MHHUDManager dismiss];
        if (is_user_exist) {
            //梁斌文
            // change by Lance 2017.10.23
            UINavigationController *nav = [self navigationWithRootControllerStr:NSStringFromClass(MHMineController.class)];
            MHMineController * vc = nav.childViewControllers[0];
            !vc.refreshBlock ? : vc.refreshBlock();
            [MHJPushRequestHandle JPushReg:nil];
            [self dismissViewControllerAnimated:NO completion:^{
                if(isSame){
                    [[MHTabBarControllerManager getMHTabbar] mh_reloadChildControllers];
                }else{
                    //你登录的帐号发生了改变，不同了,切换
                    [NSObject mh_enterMainUI];
                }
            }];
        } else {
            //因为到了这一步，此账号已经和前一个账号不同了，所以要把标记去掉，不用再回去原来的界面了，因为在志愿者申请界面，会用此字段来判断是否需要返回到调起界面,所以要置为NO
            [MHStoreGoodsHandler shareManager].volunteerApplyFalg = NO;
            MHLoSetPlotController *vc = [MHLoSetPlotController hl_instantiateControllerWithStoryBoardName:NSStringFromClass([MHLoSetPlotController class])];
            vc.setType = MHLoSetPlotTypeLogin;
            vc.phone = self.phoneTf.text;
            vc.code = self.codeTf.text;
            vc.joinVolunteerFlag = self.joinVolunteerFlag; //需求
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSString *errmsg, NSInteger errcode){
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTf) {
        if (textField.text.length - range.length + string.length == 11) {
            self.getCodeBtn.enabled = YES;
            return YES;
        } else if (textField.text.length - range.length + string.length > 11) {
            self.getCodeBtn.enabled = YES;
            return NO;
        } else {
            self.getCodeBtn.enabled = NO;
            return YES;
        }
    } else {
        if (textField.text.length - range.length + string.length > 4) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.phoneTf) {
        self.getCodeBtn.enabled = NO;
    }
    return YES;
}

#pragma mark - Event
- (void)loginAction {
    
//    if (self.phoneTf.text.length == 0 || self.codeTf.text.length == 0) {
//        return;
//    }
    
    if (![NSString mh_isMobileNumber:self.phoneTf.text]) {
        [MHHUDManager showText:@"手机号码格式有误"];
        return;
    }else if (self.codeTf.text.length != 4) {
        [MHHUDManager showText:@"验证码格式有误"];
        return;
    }
    
    [self.view endEditing:YES];
    
    //request login
    [self reuqestLogin];
}

- (void)backAction {
    MHTabBarControllerManager *tab = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav =  tab.selectedViewController ;
    UIViewController *vc = [nav.childViewControllers firstObject];
    
    //业务逻辑判断 2可以会变，2目前是“我的模块”，后续出现多个tarbarItem需要对应下标更改
    if ([vc isKindOfClass:[MHMineController class]] || [vc isKindOfClass:[MHStoreController class]]) {
        tab.selectedIndex = 0;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notificaton Imp
- (void)comeinAPP {
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        MHTabBarControllerManager *tabBarController = [[MHTabBarControllerManager alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        if(controller){
            [controller.view removeFromSuperview];
            controller = nil;
        }
    }];
 }

#pragma mark - Getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 44, 44);
        [_backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (YYLabel *)footnoteLab {
    if (!_footnoteLab) {
        _footnoteLab = [YYLabel new];
        _footnoteLab.numberOfLines = 0;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"未注册手机号码将自动注册，并表示同意“美好志愿用户协议”"];
        att.yy_color = MColorFootnote;
        att.yy_kern = @0.5;
        __weak __typeof(self)weakSelf = self;
        [att yy_setTextHighlightRange:NSMakeRange(att.length - 9, 8) color:MColorBlue backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            __strong __typeof(self)strongSelf = weakSelf;
            NSString *url = [NSString stringWithFormat:@"%@account/registerprotocolH5", baseUrl];
            HLWebViewController *web = [[HLWebViewController alloc] initWithUrl:url];
            [strongSelf.navigationController pushViewController:web animated:YES];
        }];
        _footnoteLab.attributedText = att;
    }
    return _footnoteLab;
}

@end
