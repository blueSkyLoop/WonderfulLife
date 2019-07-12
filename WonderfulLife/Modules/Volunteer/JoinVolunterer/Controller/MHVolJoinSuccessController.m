//
//  MHVolJoinSuccessController.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolJoinSuccessController.h"
#import "MHVolJoinSerController.h"
#import "MHLoginController.h"
#import "MHMineController.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "UIView+GradientColor.h"
#import "NSObject+CurrentController.h"
#import "UIViewController+HLNavigation.h"

#import "MHUserInfoManager.h"
#import "AppDelegate.h"
#import "MHThemeButton.h"

@interface MHVolJoinSuccessController ()
@property (weak, nonatomic) IBOutlet MHThemeButton *joinSerBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation MHVolJoinSuccessController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    //梁斌文
    MHMineController *vc = self.navigationController.childViewControllers[0];
    if ([vc isKindOfClass:[MHMineController class]]) {
        !vc.refreshVoStateBlock ? : vc.refreshVoStateBlock();
    }
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
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - SetUI
- (void)setUI{
    [self hiddenBackButton];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.borderWidth = 1 ;
    self.doneBtn.layer.cornerRadius = 6 ;
    self.doneBtn.layer.borderColor = MColorSeparator.CGColor;
}

#pragma mark - Event
- (IBAction)done:(id)sender {
    /* beelin 2017.8.14
    UIViewController *vc = self.navigationController.childViewControllers[0];
    if ([vc isKindOfClass:[MHLoginController class]]) {
        [self mh_fromLoginVCPop];
         [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerHomePageNotification object:nil userInfo:@{kShowInvitePage: @(NO)}];
        return;
    }
    //申请成功，发送通知，更新志愿者首页界面
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerHomePageNotification object:nil userInfo:@{kShowInvitePage: @(NO)}];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoVolunteerServerViewControllerNotification object:nil];
   */
    //go to simply version
    [NSObject mh_enterMainUI];
}

- (IBAction)joinAction:(id)sender {
    MHVolJoinSerController * vc = [[MHVolJoinSerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
