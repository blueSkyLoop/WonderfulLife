//
//  MHNormalActionSheet.h
//  01-提示框
//
//  Created by hehuafeng on 2017/7/20.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleActionSheetSureHandler)(void);   // 确定
typedef void(^TitleActionSheetCancelHandler)(void); // 取消

@interface MHTitleActionSheet : UIView
/*
 * 确定回调
 */
@property (nonatomic, copy) TitleActionSheetSureHandler sureHandler;
/*
 * 取消回调
 */
@property (nonatomic, copy) TitleActionSheetCancelHandler cancelHandler;
/*
 * 标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 标题样式底部提醒框
 */
+ (instancetype)titleActionSheetTitle:(NSString *)title sureHandler:(TitleActionSheetSureHandler)sureHandler cancelHandler:(TitleActionSheetCancelHandler)cancelHandler sureButtonColor:(UIColor *)sureColor sureButtonTitle:(NSString *)sureTitle;

@end
