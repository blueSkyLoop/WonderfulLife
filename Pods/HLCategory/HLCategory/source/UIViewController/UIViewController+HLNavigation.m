//
//  UIViewController+HLNavigation.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+HLNavigation.h"
#import "UIImage+HLColor.h"
#import "UIView+HLChainStyle.h"
#import <objc/runtime.h>

@implementation UIViewController (HLNavigation)

- (void)hl_setNavigationItemColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage hl_imageWithUIColor:color]
                                                  forBarMetrics:UIBarMetricsDefault];
    
}

- (void)hl_setNavigationItemLineColor:(UIColor *)color {
    self.navigationController.navigationBar.shadowImage = [UIImage hl_imageWithUIColor:color];
}

- (void)cleanSystemBackButton {
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}

void * const HLBackButtonKey = "HLBackButtonKey";
- (void)showBackButtonWithimage:(UIImage *)image {
    UIButton *button = objc_getAssociatedObject(self, HLBackButtonKey);
    if (button) [button removeFromSuperview];
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, HLBackButtonKey, button, OBJC_ASSOCIATION_RETAIN);
    [self.view addSubview:button];
}

- (void)backButtonEvent {
    if (self.backAction) {
        self.backAction();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)hiddenBackButton {
    UIButton *button = objc_getAssociatedObject(self, HLBackButtonKey);
    if (button) [button removeFromSuperview];
}

- (void)hl_setNavigationItemRightButton:(UIButton *)button {
    
}

- (void)hl_addNavigationItemSubView:(UIView *)subView {
    [self.navigationController.navigationBar addSubview:subView];
}



#pragma mark -

void * const HLBackActionKey = "HLBackActionKey";
- (void)setBackAction:(HLBackAction)backAction {
    objc_setAssociatedObject(self, HLBackActionKey, backAction, OBJC_ASSOCIATION_COPY);
}
-(HLBackAction)backAction {
    return objc_getAssociatedObject(self, HLBackActionKey);
}

@end
