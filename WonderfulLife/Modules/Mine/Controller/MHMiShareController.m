//
//  MHMiShareController.m
//  WonderfulLife_dev
//
//  Created by 梁斌文 on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMiShareController.h"
#import "MHMacros.h"
#import "UIViewController+UMengShare.h"
#import "MHMineRequestHandler.h"
#import "MHHUDManager.h"
#import "MHMineShare.h"
#import "YYModel.h"
#import "UIImage+Color.h"

@interface MHMiShareController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageMargin;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation MHMiShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享给好友";
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    for (UIView *view in self.containerViews) {
        view.layer.borderWidth = 1.1;
        view.layer.borderColor = MColorDisableBtn.CGColor;
    }
    if (MScreenW == 320) {
        self.top.constant = 100;
    }else{
        self.top.constant = 138*MScale;
        [self.view removeConstraint:self.imageMargin];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(MScreenW, 0.5)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (IBAction)share:(UIButton *)sender {
    NSString *platform;
    if (sender.tag == 0) {
        platform = @"微信";
    [self mh_umengShareFuncConfigWithShareWebPageToPlatformType:UMSocialPlatformType_WechatSession conentModel:[MHMineShare mineShare]];
    }else if (sender.tag == 1){
        platform = @"朋友圈";
        [self mh_umengShareFuncConfigWithShareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine conentModel:[MHMineShare mineShareWechatTimeLine]];
        
    }else if (sender.tag == 2){
        platform = @"微博";
        // 图文 + 连接
        [self mh_umengShareImageAndTextToPlatformType:UMSocialPlatformType_Sina conentModel:[MHMineShare mineShareSina]];
        return;
    }else if (sender.tag == 3){
        platform = @"QQ";
    }else{ 
        platform = nil;
    }
    


    
}


@end
