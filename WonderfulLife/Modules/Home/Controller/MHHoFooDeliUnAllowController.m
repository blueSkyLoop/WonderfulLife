//
//  MHHoFooDeliUnAllowController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/22.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoFooDeliUnAllowController.h"
#import "MHMacros.h"
#import "MHThemeButton.h"
#import "Masonry.h"
#import "UIViewController+HLNavigation.h"

@interface MHHoFooDeliUnAllowController ()
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;
@property (weak, nonatomic) IBOutlet MHThemeButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTop;

@end

@implementation MHHoFooDeliUnAllowController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食堂送餐";
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = obj.constant*MScale;
    }];
    if (MScreenW == 320) {
        self.buttonTop.constant = 50;
    }
    self.button.noShadow = YES;
    self.button.layer.cornerRadius = 28;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - 按钮点击

- (IBAction)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







