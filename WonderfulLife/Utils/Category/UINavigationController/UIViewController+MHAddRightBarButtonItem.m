//
//  UIViewController+MHAddRightBarButtonItem.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+MHAddRightBarButtonItem.h"

@implementation UIViewController (MHAddRightBarButtonItem)


- (UIButton *)mh_addRightBarButtonItemWithTitle:(NSString *)title{
    UIButton *rightBar = [[UIButton alloc] init];
    [rightBar setTitle:title forState:UIControlStateNormal];
    [rightBar setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    rightBar.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBar sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    return rightBar ;
}
@end
