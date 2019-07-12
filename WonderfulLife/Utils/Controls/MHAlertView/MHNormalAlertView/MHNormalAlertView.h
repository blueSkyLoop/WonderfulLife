//
//  MHAlertView.h
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NormalAlertViewLeftHandler)(void);  // 左边按钮点击事件
typedef void(^NormalAlertViewRightHandler)(void); // 右边按钮点击事件

@interface MHNormalAlertView : UIView
/**
 *  左边回调
 */
@property (copy,nonatomic) NormalAlertViewLeftHandler leftHandler;
/**
 *  右边回调
 */
@property (copy,nonatomic) NormalAlertViewRightHandler rightHandler;
/**
 *  标题Label
 */
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  内容Label
 */
@property (weak,nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  右边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
/**
 *  左边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

/**
 默认样式中间提醒框
 */
+ (instancetype)normalAlertViewTitle:(NSString *)title message:(NSString *)message leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;

+ (instancetype)normalAlertViewTitle:(NSString *)title message:(NSString *)message LeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle leftHandler:(NormalAlertViewLeftHandler)leftHandler rightHandler:(NormalAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;
@end
