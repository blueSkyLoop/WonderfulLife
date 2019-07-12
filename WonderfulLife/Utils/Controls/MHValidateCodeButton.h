//
//  MHValidateCodeButton.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHValidateCodeButton : UIButton
@property (nonatomic, copy) BOOL(^clickBlock)();

/** 此方法是代码实现
    若xib添加不必使用此方法
 */
+ (instancetype)validateCodeButton;

@end
