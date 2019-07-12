//
//  MHVolunteerIntroduceController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerIntroduceController.h"
#import "MHMacros.h"
#import "UIView+GradientColor.h"
#import "MHThemeButton.h"
#import "MHVoDataFillController.h"
#import "MHTabBarControllerManager.h"

@interface MHVolunteerIntroduceController ()

@property (weak, nonatomic) IBOutlet MHThemeButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MHVolunteerIntroduceController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",_count];
    self.commitButton.enabled = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (IBAction)joinImmediately:(MHThemeButton *)sender {
    [self.navigationController pushViewController:[MHVoDataFillController new] animated:YES];
    
}


- (IBAction)casual {
    
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *controller = WINDOW.rootViewController;
        MHTabBarControllerManager *tabBarController = [[MHTabBarControllerManager alloc]init];
        WINDOW.rootViewController = tabBarController;
        if(controller){
            [controller.view removeFromSuperview];
            controller = nil;
        }
    }];
}

@end


