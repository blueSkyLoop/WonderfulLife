//
//  MHVolIntrolController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/28.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolIntrolController.h"
#import "HLWebViewController.h"
#import "MHVoInviteJoinDetailScrollView.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"

@interface MHVolIntrolController ()
@property (nonatomic, strong) MHVoInviteJoinDetailScrollView *sv;
@property (nonatomic, strong) UIView  *statusBarView;
@end

@implementation MHVolIntrolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.statusBarView];
    [self.view addSubview:self.sv];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (MHVoInviteJoinDetailScrollView *)sv {
    if (!_sv) {
        _sv = [[MHVoInviteJoinDetailScrollView alloc] initWithFrame:CGRectMake(0, MTopStatus_Height, MScreenW, MScreenH - MTopStatus_Height)];
        MHWeakify(self)
        _sv.hiddenJoinButton = YES;
        [_sv setGoinDetailBlock:^(NSString *url) {
            MHStrongify(self)
            HLWebViewController *web = [[HLWebViewController alloc] initWithUrl:url];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }];
    }
    return _sv;
}

-(UIView *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MScreenW, 20)];
        _statusBarView.backgroundColor = MRGBColor(258,48,69);
    }return _statusBarView;
}
@end
