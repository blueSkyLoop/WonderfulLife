//
//  MHHoFooDeliCommitController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/24.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoFooDeliCommitController.h"
#import "MHMacros.h"
#import "MHThemeButton.h"

@interface MHHoFooDeliCommitController ()
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;
@property (weak, nonatomic) IBOutlet MHThemeButton *button;

@end

@implementation MHHoFooDeliCommitController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食堂送餐";
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = obj.constant * MScale;
    }];
    self.button.layer.cornerRadius = 28;
    self.button.noShadow = YES;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - 按钮点击

- (IBAction)pop {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end







