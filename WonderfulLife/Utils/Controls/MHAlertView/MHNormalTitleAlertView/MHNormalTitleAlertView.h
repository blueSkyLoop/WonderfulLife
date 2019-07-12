//
//  MHNormalTitleAlertView.h
//  WonderfulLife
//
//  Created by Lucas on 17/8/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NormalTitleAlertViewLeftHandler)(void);  // 左边按钮点击事件
typedef void(^NormalTitleAlertViewRightHandler)(void); // 右边按钮点击事件

@interface MHNormalTitleAlertView : UIView


/**
 *  左边回调
 */
@property (copy,nonatomic) NormalTitleAlertViewLeftHandler leftHandler;
/**
 *  右边回调
 */
@property (copy,nonatomic) NormalTitleAlertViewRightHandler rightHandler;



/**
 *  标题Label
 */
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  右边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
/**
 *  左边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *leftButton;


+ (instancetype)normalTitleAlertViewWithTitle:(NSString *)title  leftHandler:(NormalTitleAlertViewLeftHandler)leftHandler rightHandler:(NormalTitleAlertViewRightHandler)rightHandler rightButtonColor:(UIColor *)rightColor;


@end
