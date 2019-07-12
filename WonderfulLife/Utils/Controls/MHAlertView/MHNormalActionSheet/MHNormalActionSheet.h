//
//  MHNormalActionSheet.h
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NormalActionSheetTopHandler)(void);  // 顶部回调
typedef void(^NormalActionSheetBottomHandler)(void);  // 底部回调
typedef void(^NormalActionSheetCancelHandler)(void);  // 取消回调

@interface MHNormalActionSheet : UIView
/*
 * 顶部按钮回调
 */
@property (nonatomic, copy) NormalActionSheetTopHandler topHandler;
/*
 * 底部按钮回调
 */
@property (nonatomic, copy) NormalActionSheetBottomHandler bottomHandler;
/*
 * 取消按钮回调
 */
@property (nonatomic, copy) NormalActionSheetCancelHandler cancelHandler;

/*
 * 顶部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *topButton;
/*
 * 底部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
/*
 * 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/**
 默认样式底部提醒框
 */
+ (instancetype)normalActionSheetTitle:(NSString *)title topHandler:(NormalActionSheetTopHandler)topHandler bottomTitle:(NSString *)bottomTitle bottomHandler:(NormalActionSheetBottomHandler)bottomHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(NormalActionSheetCancelHandler)cancelHandler cancelColor:(UIColor *)cancelColor;

@end
