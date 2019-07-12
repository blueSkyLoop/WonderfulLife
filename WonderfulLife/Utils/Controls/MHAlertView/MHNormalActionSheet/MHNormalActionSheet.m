//
//  MHNormalActionSheet.m
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHNormalActionSheet.h"
#import "MHAlertView.h"

#define MColorToRGB(value) MColorToRGBWithAlpha(value, 0.5f)
#define MColorToRGBWithAlpha(value, alpha1) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha1]//十六进制转RGB色

#define screenW [UIScreen mainScreen].bounds.size.width;
#define screenH [UIScreen mainScreen].bounds.size.height;

@interface MHNormalActionSheet ()
/*
 * 顶部容器View
 */
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation MHNormalActionSheet
/**
 默认样式底部提醒框
 */
+ (instancetype)normalActionSheetTitle:(NSString *)title topHandler:(NormalActionSheetTopHandler)topHandler bottomTitle:(NSString *)bottomTitle bottomHandler:(NormalActionSheetBottomHandler)bottomHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(NormalActionSheetCancelHandler)cancelHandler cancelColor:(UIColor *)cancelColor {
    // 1. 创建
    MHNormalActionSheet *actionSheet = [MHNormalActionSheet loadNormalActionSheet];
    
    // 2. 设置按钮文字
    [actionSheet.topButton setTitle:title forState:UIControlStateNormal];
    [actionSheet.bottomButton setTitle:bottomTitle forState:UIControlStateNormal];
    [actionSheet.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    if (cancelColor != nil) {
        [actionSheet.cancelButton setTitleColor:cancelColor forState:UIControlStateNormal];
    }
    
    // 3. 设置回调
    actionSheet.topHandler = topHandler;
    actionSheet.bottomHandler = bottomHandler;
    actionSheet.cancelHandler = cancelHandler;
    
    // 4. 返回
    return actionSheet;
}

/*
 * 加载默认样式底部提醒框
 */
+ (instancetype)loadNormalActionSheet {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置圆角
    self.topView.layer.cornerRadius = 4;
    self.topView.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 8;
    self.cancelButton.layer.masksToBounds = YES;
}


#pragma mark - 点击事件
/*
 * 顶部按钮点击事件
 */
- (IBAction)topButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.topHandler) {
        self.topHandler();
    }
}

/*
 * 底部按钮点击事件
 */
- (IBAction)bottomButtonClick:(UIButton *)sender {
    [[MHAlertView sharedInstance] dismiss];
    if (self.bottomHandler) {
        self.bottomHandler();
    }
}

/*
 * 取消按钮点击事件
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
