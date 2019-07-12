//
//  MHMineIntQrCodeController.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineIntQrCodeController.h"
#import "MHMineQrInfoHeaderView.h"

#import "MHMineMerchantInfoModel.h"
#import "MHMineIntQrCodeHandler.h"
#import "UIImage+Color.h"

#import "UIViewController+HLNavigation.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MHHUDManager.h"
#import "UILabel+isNull.h"
#import "UIImageView+Category.h"
#import "MHMacros.h"

@interface MHMineIntQrCodeController ()
@property (strong, nonatomic) MHMineQrInfoHeaderView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView * gradientBGView;
@property (weak, nonatomic) IBOutlet UIView *contentBGView;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (weak, nonatomic) IBOutlet UILabel *BarQRLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceOfAccountLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) MHMineMerchantInfoModel  *model;

@end

@implementation MHMineIntQrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"向商家付款";

    self.gradientBGView.image = [UIImage mh_gradientImageWithBounds:CGRectMake(0, 0, MScreenW, CGRectGetHeight(self.gradientBGView.frame)) direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];

    self.contentBGView.layer.cornerRadius = 6;
    self.contentBGView.layer.masksToBounds = YES;
    
    [self request];
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

#pragma mark -  Request

- (void)request {
    [self.loadingView startAnimating];
    [MHMineIntQrCodeHandler mineIntQrCodeRequestCallBack:^(BOOL Success, MHMineMerchantInfoModel *model) {
        self.model = model ;
        [self setUI];
    } Failure:^(NSString *errmsg) {
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            [MHHUDManager showErrorText:errmsg];
        });
    }];
}

#pragma mark - SetUI
- (void)setUI {

    self.balanceOfAccountLabel.text = [NSString stringWithFormat:@"积分余额:%@",self.model.score];
    
    UIImageView *logo = [UIImageView new];
    [logo sd_setImageWithURL:[NSURL URLWithString:self.model.user_s_img] placeholderImage:MAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        [self.QRImage mh_qrCodeImageWithContent:self.model.qr_code logo:logo.image];
    }];
    
    [self.BarQRLab mh_isNullText:[NSString stringWithFormat:@"付款编码:%@",self.model.bar_code]];
}

@end
