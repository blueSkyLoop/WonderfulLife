//
//  MHMineColQrCodeController.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineColQrCodeController.h"
#import "MHMineQrInfoHeaderView.h"

#import "MHMineMerchantInfoModel.h"
#import "MHMineMerchantHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "UIViewController+HLNavigation.h"
#import "UIImageView+Category.h"
#import <Masonry.h>
#import "MHHUDManager.h"
#import "MHMacros.h"
@interface MHMineColQrCodeController ()
@property (strong, nonatomic) MHMineQrInfoHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;

@property (nonatomic, strong) MHMineMerchantInfoModel  *model;
@end

@implementation MHMineColQrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MHHUDManager show];
    
    [MHMineMerchantHandler mineMerColQrCodeRequestWithParma:@{@"merchant_id":self.merchant_id} Block:^(MHMineMerchantInfoModel *model, BOOL Success) {
        self.model =  model ;
        [self setUI];
        [MHHUDManager dismiss];
    } Failure:^(NSString *errmsg) {
        [MHHUDManager showErrorText:errmsg];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setUI {
    self.headerView = [MHMineQrInfoHeaderView mineQRInfoHeaderView:self.model];
    [self.topView addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
  
    UIImageView *logo = [UIImageView new];
    [logo sd_setImageWithURL:[NSURL URLWithString:self.model.user_s_img] placeholderImage:MAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.QRImage mh_qrCodeImageWithContent:self.model.qr_code logo:logo.image];
    }];
    
}
@end

