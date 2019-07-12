//
//  MHNormalActionSheet.m
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHTitleActionSheet.h"
#import "MHAlertView.h"

@interface MHTitleActionSheet ()
/*
 * 顶部容器View
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/*
 * 底部取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/*
 * 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation MHTitleActionSheet
/**
 标题样式底部提醒框
 */
+ (instancetype)titleActionSheetTitle:(NSString *)title sureHandler:(TitleActionSheetSureHandler)sureHandler cancelHandler:(TitleActionSheetCancelHandler)cancelHandler sureButtonColor:(UIColor *)sureColor sureButtonTitle:(NSString *)sureTitle {
    // 1. 创建
    MHTitleActionSheet *titleActionSheet = [MHTitleActionSheet loadTitleActionSheet];
    
    // 2. 设置属性
    titleActionSheet.titleLabel.text = title;
    titleActionSheet.sureHandler = sureHandler;
    titleActionSheet.cancelHandler = cancelHandler;
    if (sureTitle != nil) {
        [titleActionSheet.sureButton setTitle:sureTitle forState:UIControlStateNormal];
    }
    if (sureColor != nil) {
        [titleActionSheet.sureButton setTitleColor:sureColor forState:UIControlStateNormal];
    }
    
    // 3. 返回
    return titleActionSheet;
}


/**
 加载标题样式底部提醒框
 */
+ (instancetype)loadTitleActionSheet {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.topView.layer.cornerRadius = 12;
    self.topView.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 8;
    self.cancelButton.layer.masksToBounds = YES;
}

#pragma mark - 点击事件
/*
 * 确定点击
 */
- (IBAction)sureButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.sureHandler) {
        self.sureHandler();
    }
}

/*
 * 取消点击
 */
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
