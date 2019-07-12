//
//  MHPromptSuccessController.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCertificationSuccessController.h"

#import <Masonry.h>
#import "UIImage+Color.h"
#import "NSObject+isNull.h"
#import "UIView+GradientColor.h"
#import "UILabel+HLLineSpacing.h"
#import "MHMacros.h"
#import "MHConst.h"

#import "MHMineController.h"
#import "MHHomeController.h"
#import "MHVolunteerController.h"
#import "MHLoginController.h"

#import "MHUserInfoManager.h"
#import "AppDelegate.h"

#import "UINavigationController+MHDirectPop.h"
#import "MHStoreGoodsHandler.h"
#import "NSObject+CurrentController.h"

@interface MHCertificationSuccessController ()
/**
 *  标题
 */
@property (strong,nonatomic) UILabel *titleLB;

/**
 *  详细描述
 */
@property (strong,nonatomic) UILabel *contentLB;


/**
 *  返回Btn
 */
@property (strong,nonatomic) UIButton *backBtn;

@property (nonatomic, copy)   NSString * imageUrl;
@end

@implementation MHCertificationSuccessController


#pragma mark - Life Cycle
- (instancetype)initWithType:(MHCertificationSuccessType)type {
    self = [super init];
    if (self) {
        if (type == MHCertificationSuccessTypeNone) {
            [self initLabelWithTitle:@"认证成功"];
            self.imageUrl = @"ce_authenticationsuccess";
            [self initImageView:YES];
        } else if (type == MHCertificationSuccessTypeHouseholdCommit) {
            self.imageUrl = @"ce_submitsuccess";
            [self initLabelWithTitle:@"提交成功"];
            [self initContentLBWithContent:@"您的住户认证申请已提交成功，\n工作人员将会在3个工作日内审核您的申请，\n敬请留意系统通知！"];
            [self initImageView:NO];
        } else if (type == MHCertificationSuccessTypeVolSer || type == MHCertificationSuccessTypeVolNoSer) {
            self.imageUrl = @"vo_joinsuccess";
            [self initLabelWithTitle:@"申请成功"];

            if (type == MHCertificationSuccessTypeVolNoSer) { //  只参与公益服务
            [self initContentLBWithContent:@"恭喜您已成为志愿者"];
            }else{ // 有参与服务项目
            [self initContentLBWithContent:@"恭喜您已成为志愿者，所申请加入的服务项目负责人将会尽快审核并与您联系"];
            }
             [self initImageView:NO];
        } }
    self.type = type ;
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    if (self.type==MHCertificationSuccessTypeHouseholdCommit) {// 住户认证
        user.validate_status = @1;
        
    }else if (self.type == MHCertificationSuccessTypeNone){
        user.validate_status = @2;
    }
    
    
    UIViewController *vc = self.navigationController.viewControllers[0];
    
    if ([vc isKindOfClass:[MHMineController class]]) {
        MHMineController * mine = (MHMineController *)vc;
        if (self.type==MHCertificationSuccessTypeVolSer || self.type == MHCertificationSuccessTypeVolNoSer) {
            !mine.refreshVoStateBlock ? : mine.refreshVoStateBlock();
        }else {
            !mine.refreshCetifiStateBlock ? : mine.refreshCetifiStateBlock(self.type==MHCertificationSuccessTypeHouseholdCommit ? 1 : 2);
        }
    }else if ([vc isKindOfClass:[MHHomeController class]]){
        MHMineController * mine = [self getMinController];
        if(!mine) return;
        !mine.refreshCetifiStateBlock ? : mine.refreshCetifiStateBlock(self.type ==MHCertificationSuccessTypeHouseholdCommit ? 1 : 2);
    }
}

- (MHMineController *)getMinController{
    MHMineController *minVC;
    for(UINavigationController *nav in self.tabBarController.viewControllers){
        if([[nav.viewControllers firstObject] isKindOfClass:[MHMineController class]]){
            minVC = [nav.viewControllers firstObject];
            break;
        }
    }
    return minVC;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


#pragma mark - SetUI
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define MAGIR 24
- (void)initLabelWithTitle:(NSString *)title{
    self.titleLB = [UILabel new];
    self.titleLB.font  = [UIFont systemFontOfSize:34.0];
    self.titleLB.textAlignment = NSTextAlignmentCenter ;
    self.titleLB.textColor = MColorTitle ;
    self.titleLB.text = title ;
    [self.view addSubview:self.titleLB];
    WS(ws);
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@144);
        make.height.equalTo(@48);
        make.centerX.equalTo(ws.view);
        make.top.equalTo(@44);
    }];
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:19.0];
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.layer.cornerRadius = 5;
    self.backBtn.layer.borderWidth = .5;
    self.backBtn.layer.borderColor = MColorSeparator.CGColor ;
    self.backBtn.backgroundColor = [UIColor whiteColor];
    
    [self.backBtn setTitle:@"返\t回" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
    [self.backBtn addTarget:self
                      action:@selector(backAction)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(MAGIR);
        make.right.equalTo(ws.view).offset(-MAGIR);
        make.bottom.equalTo(ws.view).offset(-40);
        make.height.equalTo(@56);
    }];
//    [self.backBtn layoutIfNeeded];
//    [self.backBtn mh_gradientSetMainColor];

}


- (void)initContentLBWithContent:(NSString *)content{
    self.contentLB = [UILabel new];
    self.contentLB.font  = [UIFont systemFontOfSize:14.0];
    self.contentLB.textAlignment = NSTextAlignmentCenter ;
    self.contentLB.numberOfLines = 0 ;
    self.contentLB.textColor = MColorTitle ;
    self.contentLB.text = content ;
    [self.contentLB hl_setLineSpacing:8 text:content];
    [self.view addSubview:self.contentLB];
    WS(ws);
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.titleLB.mas_bottom).offset(25);
        make.left.equalTo(ws.view).offset(38);
        make.right.equalTo(ws.view).offset(-38);
    }];

}


- (void)initImageView:(BOOL)isOnlyImage{
    // YES  frame  居中一点   ;  NO   frame  往下偏移一点
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageUrl]];
    [self.view addSubview:iv];
    WS(ws);
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@220);
        make.centerX.equalTo(ws.view);
        if (isOnlyImage) {
            if (isIPhone5()) {
            make.centerY.equalTo(ws.view);
            }else if(isIPhone6){
            make.top.equalTo(ws.titleLB.mas_bottom).offset(57);
            }else{
            make.top.equalTo(ws.titleLB.mas_bottom).offset(70);
            }
            
            
        }else{
            if (isIPhone5()) {
             make.centerY.equalTo(ws.view).mas_offset(40);
            }else{
             make.top.equalTo(ws.contentLB.mas_bottom).offset(57);
            }
        }
    }];
}



#pragma mark - Event 申请成功志愿者点击返回
- (void)backAction{
    
    //从支付界面过来的申请，成功之后要回去支付界面
    if([MHStoreGoodsHandler shareManager].volunteerApplyFalg){
        [MHStoreGoodsHandler shareManager].volunteerApplyFalg = NO;
        //保存一下支付界面，让其返回到这个界面
        [self.navigationController saveDirectViewControllerName:[MHStoreGoodsHandler shareManager].registVolunteerClassName];
        [MHStoreGoodsHandler shareManager].registVolunteerClassName = nil;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController directTopControllerPop];
        return;
    }
    
    UIViewController *vc = self.navigationController.childViewControllers[0];
    
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    
    if (self.type == MHCertificationSuccessTypeVolSer || self.type == MHCertificationSuccessTypeVolNoSer){ // 志愿者申请
        user.is_volunteer = @1;
    }
    [user saveUserInfoData];
    
    if ([vc isKindOfClass:[MHMineController class]] || [vc isKindOfClass:[MHHomeController class]]) {
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.mh.myroom.refresh" object:nil];
        [self.navigationController saveDirectViewControllerName:@"MHHomePayMyRoomController"];
        self.navigationController.navigationBarHidden = NO;
        UIViewController *controller = [self.navigationController findDirectViewController];
        if(controller){
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if([vc isKindOfClass:[MHVolunteerController class]]){// 返回志愿者界面
        
        [NSObject mh_enterMainUI];
        
    }else if([vc isKindOfClass:[MHLoginController class]]){
        [self dismissViewControllerAnimated:NO completion:^{
            [NSObject mh_enterMainUI];
        }];
    }
}

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end
