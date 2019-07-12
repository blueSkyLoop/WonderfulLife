//
//  XXNavigationControllerManager.m
//  BaseFramework
//
//  Created by Mantis-man on 16/1/16.
//  Copyright © 2016年 Mantis-man. All rights reserved.
//

#import "MHNavigationControllerManager.h"
#import "MHMacros.h"
#import "MHVoDataAddressController.h"
#import "MHVoDataPhoneController.h"
#import "MHVoServerPageController.h"
#import "MHVolIntrolController.h"
#import "MHMineMerchantController.h"
#import "MHMineIntQrCodeController.h"
#import "MHMineColQrCodeController.h"
#import "UINavigationController+MHDirectPop.h"
@interface MHNavigationControllerManager ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MHNavigationControllerManager

+ (void)load{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [self navigationBarWhite];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count) {
        UIButton *backButton = [[UIButton alloc] init];
        if ([viewController isKindOfClass:[MHVoDataPhoneController class]] || [viewController isKindOfClass:[MHVoDataAddressController class]]) {
            [backButton setTitle:@"取消" forState:UIControlStateNormal];
            [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -24, 0, 0)];
            [backButton setTitleColor:MRGBColor(50, 64, 87) forState:UIControlStateNormal];
            backButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        if ([viewController isKindOfClass:[MHVoServerPageController class]] ||  [viewController isKindOfClass:[MHVolIntrolController class]] || [viewController isKindOfClass:[MHMineMerchantController class]] || [viewController isKindOfClass:[MHMineIntQrCodeController class]] || [viewController isKindOfClass:[MHMineColQrCodeController class]]) {
           [backButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
        } else {
            [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        }
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        [backButton sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.interactivePopGestureRecognizer.enabled = NO;
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        //add by Lance
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if([self needCheck]){
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.childViewControllers];
        [muArr addObject:viewController];
        [self handleDirectPopWithControllers:muArr];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if([self needCheck]){
        [self handleDirectPopWithControllers:self.childViewControllers];
    }
    return [super popViewControllerAnimated:animated];
}

//处理保存的类名，以防已经跳过这个控制器了，但还保存着这个控制器的类名
- (void)handleDirectPopWithControllers:(NSArray *)controllers{
    NSMutableArray *classNames = [NSMutableArray arrayWithCapacity:controllers.count];
    for(UIViewController *controller in controllers){
        NSString *name = NSStringFromClass(controller.class);
        [classNames addObject:name];
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self checkClassNameExsit:classNames];
    });
    
}

- (void)back{
    if ([self.topViewController conformsToProtocol:@protocol(MHNavigationControllerManagerProtocol)]) {
        UIViewController *topVc = self.topViewController;
        BOOL b = [(id<MHNavigationControllerManagerProtocol>)topVc bb_ShouldBack];
        if (b) {
            [self popViewControllerAnimated:YES];
        }
    }else{
        [self popViewControllerAnimated:YES];
    }
}

- (void)navigationBarTranslucent{
//    self.navigationBar.translucent = YES;
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef conntext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(conntext, [UIColor clearColor].CGColor);
    CGContextFillRect(conntext, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)navigationBarWhite{
//    self.navigationBar.translucent = YES;
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef conntext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(conntext, [UIColor whiteColor].CGColor);
    CGContextFillRect(conntext, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count <= 1) {
            return NO;
        }
        if ([self.topViewController conformsToProtocol:@protocol(MHNavigationControllerManagerProtocol)]) {
            UIViewController *topVc = self.topViewController;
            BOOL b = [(id<MHNavigationControllerManagerProtocol>)topVc bb_ShouldBack];
            return b;
        }
    }
    return YES;
}

// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer: (UIGestureRecognizer *) otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass: UIScreenEdgePanGestureRecognizer.class];
}


@end




