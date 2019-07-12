//
//  MHTextFieldAlertView.h
//  01-封装提示框
//
//  Created by hehuafeng on 2017/7/21.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextFieldAlertViewCancelHandler)(void);  // 取消回调
typedef void(^TextFidleAlertViewSureHandler)(NSString *text);  // 确定回调

@interface MHTextFieldAlertView : UIView
/**
 取消回调block
 */
@property (nonatomic, copy) TextFieldAlertViewCancelHandler cancelHandler;
/**
 确定回调block
 */
@property (nonatomic, copy) TextFidleAlertViewSureHandler sureHandler;

/**
 标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 文本框样式中间提醒框
 */
+ (instancetype)textFieldAlertViewTitle:(NSString *)title sureHandler:(TextFidleAlertViewSureHandler)sureHandler cancelHandler:(TextFieldAlertViewCancelHandler)cancelHandler;

@end
