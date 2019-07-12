//
//  MHAlertView.m
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHAlertView.h"

#define MColorToRGB(value) MColorToRGBWithAlpha(value, 0.5f)
#define MColorToRGBWithAlpha(value, alpha1) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha1]//十六进制转RGB色

// 单例对象
static MHAlertView *_instance = nil;

@interface MHAlertView ()

@end

@implementation MHAlertView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MColorToRGB(0X1F2D3D);
    }
    return self;
}

/**
 触摸移除
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

/**
 移除提醒框
 */
- (void)dismiss {
    // 移除所有子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

#pragma mark - 单例对象
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

#pragma mark - 显示中间提示框
/**
 显示默认样式中间提醒框
 */
- (void)showNormalAlertViewTitle:(NSString *)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    // 显示
    MHNormalAlertView *norAlertView = [MHNormalAlertView normalAlertViewTitle:title message:message leftHandler:leftHandler rightHandler:rightHandler rightButtonColor:rightColor];
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    norAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    norAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norAlertView];
    [keyWindow addSubview:self];
}

/**
 显示默认样式中间提醒框,按钮标题可修改
 */
- (void)normalAlertViewTitle:(NSString *)title message:(NSString *)message LeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor{
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    // 显示
    MHNormalAlertView *norAlertView = [MHNormalAlertView normalAlertViewTitle:title message:message LeftTitle:leftTitle RightTitle:rightTitle leftHandler:leftHandler rightHandler:rightHandler rightButtonColor:rightColor];
    
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    norAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    norAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norAlertView];
    [keyWindow addSubview:self];
}

/** 普通提示框，只有标题*/
- (void)showNormalTitleAlertViewWithTitle:(NSString *)title  leftHandler:(NormalTitleAlertViewLeftHandler)leftHandler rightHandler:(NormalTitleAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor{
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:19.0]};
    CGFloat titleH = [title boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    // 显示
    MHNormalTitleAlertView *norAlertView = [MHNormalTitleAlertView normalTitleAlertViewWithTitle:title leftHandler:leftHandler rightHandler:rightHandler rightButtonColor:rightColor];
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 220 + titleH;
    norAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    norAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norAlertView];
    [keyWindow addSubview:self];

}



/**
 显示标题样式中间提醒框
 */
- (MHMessageAlertView *)showMessageAlertViewTitle:(NSString *)title message:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height + 5;
    
    // 显示
    MHMessageAlertView *messageAlertView = [MHMessageAlertView messageAlertViewTitle:title message:message sureHandler:sureHandler];
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    if (title == nil) {
        alertH = alertH - 26;
    }
    messageAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    messageAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:messageAlertView];
    [keyWindow addSubview:self];
    return messageAlertView ;
}

/**
 显示文本框样式中间提醒框
 */
- (void)showTextFieldAlertViewTitle:(NSString *)title sureHandler:(TextFidleAlertViewSureHandler)sureHandler cancelHandler:(TextFieldAlertViewCancelHandler)cancelHandler {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 显示
    MHTextFieldAlertView *textFieldAlertView = [MHTextFieldAlertView textFieldAlertViewTitle:title sureHandler:sureHandler cancelHandler:cancelHandler];
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 215;
    textFieldAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    textFieldAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:textFieldAlertView];
    [keyWindow addSubview:self];
}

#pragma mark - 显示底部提示框
/**
 显示默认样式底部提醒框
 */
- (void)showNormalActionSheetTitle:(NSString *)title topHandler:(NormalActionSheetTopHandler)topHandler bottomTitle:(NSString *)bottomTitle bottomHandler:(NormalActionSheetBottomHandler)bottomHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(NormalActionSheetCancelHandler)cancelHandler cancelColor:(UIColor *)cancelColor {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 显示
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    MHNormalActionSheet *norActionSheet = [MHNormalActionSheet normalActionSheetTitle:title topHandler:topHandler bottomTitle:bottomTitle bottomHandler:bottomHandler cancelTitle:cancelTitle cancelHandler:cancelHandler cancelColor:cancelColor];
    norActionSheet.frame = CGRectMake(0, height, width, 228);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norActionSheet];
    [keyWindow addSubview:self];
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        norActionSheet.frame = CGRectMake(0, height - 228, width, 228);
    }];
}

/**
 显示标题样式底部提醒框
 */
- (void)showTitleActionSheetTitle:(NSString *)title sureHandler:(TitleActionSheetSureHandler)sureHandler cancelHandler:(TitleActionSheetCancelHandler)cancelHandler sureButtonColor:(UIColor *)sureButtonColor sureButtonTitle:(NSString *)sureButtonTitle {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 显示
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    MHTitleActionSheet *titleActionSheet = [MHTitleActionSheet titleActionSheetTitle:title sureHandler:sureHandler cancelHandler:cancelHandler sureButtonColor:sureButtonColor sureButtonTitle:sureButtonTitle];
    titleActionSheet.frame = CGRectMake(0, height, width, 217);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:titleActionSheet];
    [keyWindow addSubview:self];
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        titleActionSheet.frame = CGRectMake(0, height - 217, width, 217);
    }];
}

/**
 版本更新(需要更新)
 */
- (void)showVersionAlertViewMessage:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    
    NSString *title = @"发现新版本,请立刻更新";
    
    // 显示
    MHNormalAlertView *norAlertView = [MHNormalAlertView normalAlertViewTitle:title message:message leftHandler:leftHandler rightHandler:rightHandler rightButtonColor:rightColor];

    norAlertView.contentLabel.textColor = MColorToRGBWithAlpha(0X324057, 1);
    norAlertView.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    norAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    norAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norAlertView];
    [keyWindow addSubview:self];
}

/**
 版本更新(强制更新)
 */
+ (void)showVersionAlertViewMessage:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backgroudView.backgroundColor = MColorToRGB(0X1F2D3D);
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height + 5;
    
    NSString *title = @"发现新版本,请立刻更新";
    // 显示
    MHMessageAlertView *messageAlertView = [MHMessageAlertView messageAlertViewTitle:title message:message sureHandler:^{
        sureHandler();
    }];
    messageAlertView.messageLabel.textColor = MColorToRGBWithAlpha(0X324057, 1);
    messageAlertView.messageLabel.textAlignment = NSTextAlignmentLeft;

    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    if (title == nil) {
        alertH = alertH - 26;
    }
    messageAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    messageAlertView.center = CGPointMake(width / 2, height / 2);
    

    [backgroudView addSubview:messageAlertView];
    [keyWindow addSubview:backgroudView];
}

+ (void)showMessageAlertViewMessage:(NSString *)message sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backgroudView.backgroundColor = MColorToRGB(0X1F2D3D);
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height + 5;
    
    
    // 显示
    MHMessageAlertView *messageAlertView = [MHMessageAlertView messageAlertViewTitle:nil message:message sureHandler:^{
        [backgroudView removeFromSuperview];
        sureHandler();
    }];
    messageAlertView.messageLabel.textColor = MColorToRGBWithAlpha(0X324057, 1);
    messageAlertView.titleLabel.hidden = YES;
    messageAlertView.titleLabelContraint.constant = 0;
    messageAlertView.messageLabel.font = [UIFont systemFontOfSize:19];
    
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;

    messageAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    messageAlertView.center = CGPointMake(width / 2, height / 2);
    
    
    [backgroudView addSubview:messageAlertView];
    [keyWindow addSubview:backgroudView];


}

+ (void)showMessageAlertViewMessage:(NSString *)message ConfirmName:(NSString *)confirmName sureHandler:(MessageAlertViewSureHandler)sureHandler {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backgroudView.backgroundColor = MColorToRGB(0X1F2D3D);
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height + 5;
    
    
    // 显示
    MHMessageAlertView *messageAlertView = [MHMessageAlertView messageAlertViewTitle:nil message:message ConfirmName:(NSString *)confirmName sureHandler:^{
        [backgroudView removeFromSuperview];
        sureHandler();
    }];
    messageAlertView.messageLabel.textColor = MColorToRGBWithAlpha(0X324057, 1);
    messageAlertView.titleLabel.hidden = YES;
    messageAlertView.titleLabelContraint.constant = 0;
    messageAlertView.messageLabel.font = [UIFont systemFontOfSize:19];
    
    CGFloat margin = 24;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    
    messageAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    messageAlertView.center = CGPointMake(width / 2, height / 2);
    
    
    [backgroudView addSubview:messageAlertView];
    [keyWindow addSubview:backgroudView];
    
    
}
/**
 标题，内容 字体颜色相同
 */
- (void)showSameTextColorAlertViewTitle:(NSString*)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor {
    // 获取keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGFloat width = keyWindow.bounds.size.width;
    CGFloat height = keyWindow.bounds.size.height;
    
    // 计算内容文字大小
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    CGFloat titleH = [message boundingRectWithSize:CGSizeMake(width - 96, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    
    // 显示
    MHNormalAlertView *norAlertView = [MHNormalAlertView normalAlertViewTitle:title message:message leftHandler:leftHandler rightHandler:rightHandler rightButtonColor:rightColor];
    
    norAlertView.contentLabel.textColor = MColorToRGBWithAlpha(0X324057, 1);
    
    CGFloat margin = 16;
    CGFloat alertW = width - margin * 2;
    CGFloat alertH = 166 + titleH;
    norAlertView.bounds = CGRectMake(0, 0, alertW, alertH);
    norAlertView.center = CGPointMake(width / 2, height / 2);
    self.frame = CGRectMake(0, 0, width, height);
    [self addSubview:norAlertView];
    [keyWindow addSubview:self];
}

@end
