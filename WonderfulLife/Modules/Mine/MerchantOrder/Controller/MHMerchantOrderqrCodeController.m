//
//  MHMerchantOrderControllerViewController.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderqrCodeController.h"
#import "UIImage+Color.h"
#import "MHMacros.h"

#import "UIImageView+Category.h"
#import "UIViewController+HLNavigation.h"


@interface MHMerchantOrderqrCodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

@end

@implementation MHMerchantOrderqrCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerImageView.image = [UIImage mh_gradientImageWithBounds:self.headerImageView.bounds direction:UIImageGradientDirectionDown colors:@[MColorToRGB(0XFF586E),MColorToRGB(0XFF7E60)]];
    
    self.title = @"订单消费二维码";
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    [confirm sizeToFit];
    [confirm setContentEdgeInsets:UIEdgeInsetsMake(0, -24, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(popLastController) forControlEvents:UIControlEventTouchUpInside];

    [self.qrCodeImageView mh_QRencodeQRImageWithContent:self.qrcodeUrl];
    self.orderNoLabel.text = self.order_no;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)popLastController {
    [self.navigationController popViewControllerAnimated:YES];
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
