//
//  WHVolunteerController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerController.h"
#import "MHVoServerPageController.h"
#import "MHVoDataFillController.h"
#import "MHLoginController.h"
#import "MHNavigationControllerManager.h"
#import "HLWebViewController.h"
#import "MHVolIntrolController.h"

#import "MHVoHomePageHeaderView.h"
#import "MHVoInviteJoinView.h"
#import "MHVoInviteJoinDetailScrollView.h"

#import "MHVolunteerDataHandler.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "MHWeakStrongDefine.h"
#import "MHUserInfoManager.h"
#import "MHAreaManager.h"


#import "UIViewController+PresentLoginController.h"
#import "UIViewController+HLNavigation.h"
#import "MHVoCultivateController.h"

#import "UIView+MHFrame.h"
#import "UIImage+Color.h"
@interface MHVolunteerController ()<UIScrollViewDelegate>
@property (nonatomic, strong) MHVoInviteJoinDetailScrollView *sv;
@property (nonatomic, strong) MHVoInviteJoinView *jv;
@property (nonatomic, strong)  MHVoHomePageHeaderView *hv;
@property (nonatomic, strong) UIView  *statusBarView;

@property (nonatomic, copy) NSString *headcount;
@end

@implementation MHVolunteerController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = MRGBColor(249,250,252);
    [self setupConfig];
    [self showControls];
    [self addObserver];

    //需求,简约
    NSString *key = [NSString stringWithFormat:@"simplyFlag--%@", [MHUserInfoManager sharedManager].user_id];
    BOOL isSimplyFlag = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (isSimplyFlag) {
        MHVoServerPageController *vc = [[MHVoServerPageController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        //判断是弹过窗
        NSString *key = [NSString stringWithFormat:@"showed--%@", [MHUserInfoManager sharedManager].user_id];
        BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        if (!isShowed && [[MHUserInfoManager sharedManager].is_volunteer isEqualToNumber:@1]) {
            MHVoServerPageController *vc = [[MHVoServerPageController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}
- (void)removeData {
    [[MHUserInfoManager sharedManager] removeUserInfoData];
    [[MHAreaManager sharedManager] removeAreaData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
     [self requestGetHeadcount];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupConfig {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsHorizontalScrollIndicator = NO ;
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)showControls {
    if ([MHUserInfoManager sharedManager].isLogin) {
        switch ([MHUserInfoManager sharedManager].is_volunteer.integerValue) {
            case 1:
            {
                self.tableView.tableHeaderView = self.hv;
                self.tableView.scrollEnabled = NO;
            }
                break;
            default:
            {
                [self.view addSubview:self.sv];
                [self.view addSubview:({
                    self.tableView.scrollEnabled = NO;
                    self.jv;
                })];
                    [self.view addSubview:self.statusBarView];
            }
                break;
        }
    } else {
        [self.view addSubview:self.sv];
        [self.view addSubview:({
            self.tableView.scrollEnabled = NO;
            self.jv;
        })];
            [self.view addSubview:self.statusBarView];
    }
    
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kReloadVolunteerHomePageNotification object:nil];
}

#pragma mark - Request
- (void)requestGetHeadcount {
    [MHVolunteerDataHandler getVolunteerHeadcountSuccess:^(NSString *count) {
        if (self.jv) {
            self.jv.headcount = count;
        }
        if (self.sv) {
            self.sv.headcount = count;
        }
        if (self.hv) {
            self.hv.headcount = count;
        }
        
    } failure:^(NSString *errmsg) {
       //errmsg 为上一次缓存人数
        if (self.jv) {
            self.jv.headcount = errmsg;
        }
        if (self.sv) {
            self.sv.headcount = errmsg;
        }
        if (self.hv) {
            self.hv.headcount = errmsg;
        }
    }];
}

#pragma mark - Notification Imp
- (void)reloadView:(NSNotification *)noti {
    if ([noti.userInfo[kShowInvitePage] isEqualToNumber:@(YES)]) {
        [self.sv removeFromSuperview];
        [self.jv removeFromSuperview];
        [self.statusBarView removeFromSuperview];
        self.sv.hidden = NO;
        self.jv.hidden = NO;
        self.statusBarView.hidden = NO ;
        self.tableView.tableHeaderView = nil;
        [self.view addSubview:self.sv];
        [self.view addSubview:({
            self.tableView.scrollEnabled = NO;
            self.jv;
        })];
         [self.view addSubview:self.statusBarView];
    } else {
        self.sv.hidden = YES;
        self.jv.hidden = YES;
        self.statusBarView.hidden = YES ;
        self.tableView.tableHeaderView = self.hv;
        self.tableView.scrollEnabled = YES;
    }
    
    //reqeust 重新刷新志愿者人数
    [self requestGetHeadcount];
}

- (void)goServerViewController {
    if ([[MHUserInfoManager sharedManager].is_volunteer isEqualToNumber:@1]) {
        MHVoServerPageController *vc = [[MHVoServerPageController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Private
- (void)p_checkisLogin {
    BOOL isLogin = [MHUserInfoManager sharedManager].isLogin;
    if (isLogin) {
        MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
         [self presentLoginControllerWithJoinVolunteer:YES];
    }
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - ScorllViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.sv) {
        if (scrollView.contentOffset.y <= 0) {
            [self.jv showSelf];
            self.statusBarView.backgroundColor = MRGBColor(254,168,58);
        }
    }
}
#pragma mark - Getter
- (MHVoInviteJoinDetailScrollView *)sv {
    if (!_sv) {
        _sv = [[MHVoInviteJoinDetailScrollView alloc] initWithFrame:CGRectMake(0, MTopStatus_Height, MScreenW, MScreenH - MToolBarHeight - MTopStatus_Height)];
        [_sv addSubview:({
            _sv.swipeUpImv.frame = CGRectMake(_sv.mh_centerX - 10, 15, 26.5, 16.5);
            _sv.swipeUpImv;
        })];
        _sv.delegate = self;
        _sv.bounces = NO;
        MHWeakify(self)
        [_sv setClickInviteBlock:^{
            MHStrongify(self)
            [self p_checkisLogin];
        }];
        [_sv setGoinDetailBlock:^(NSString *url) {
             MHStrongify(self)
            HLWebViewController *web = [[HLWebViewController alloc] initWithUrl:url];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }];
    }
    return _sv;
}

- (MHVoInviteJoinView *)jv {
    if (!_jv) {
        MHWeakify(self)
        _jv = [[MHVoInviteJoinView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH - MToolBarHeight)];
        [_jv setClickPanUpBlock:^{
            MHStrongify(self)
            self.statusBarView.backgroundColor = MRGBColor(258,48,69);
        }];
        [_jv setClickInviteBlock:^{
            MHStrongify(self)
            [self p_checkisLogin];
        }];
    }
    return _jv;
}

- (MHVoHomePageHeaderView *)hv {
    if (!_hv) {
        _hv = [MHVoHomePageHeaderView voHomePageHeaderView];
        MHWeakify(self)
        [_hv setClickPushCultivateBlock:^{
            MHStrongify(self)
            MHVoCultivateController *vc = [MHVoCultivateController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_hv setClickPushVolunteerIntrolBlock:^{
            MHStrongify(self)
            MHVolIntrolController *vc = [[MHVolIntrolController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_hv setClickPushServerBlock:^{
            MHStrongify(self)
            MHVoServerPageController *vc = [[MHVoServerPageController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _hv;
}

-(UIView *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MScreenW, 20)];
        _statusBarView.backgroundColor = MRGBColor(254,168,58);
    }return _statusBarView;
}

@end
