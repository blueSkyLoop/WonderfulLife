//
//  LPayAlertView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "LPasswordView.h"
typedef NS_ENUM(NSInteger,PayActionType) {
    Pay_inputPasswordComple = 1,         //密码输入完成
    Pay_forgetPassword,                  //忘记密码
    Pay_back                             //返回
};

@interface LPayAlertView : UIView

@property (nonatomic,strong)UILabel *atitleLable;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)LPasswordView *inputBgView;
@property (nonatomic,strong)UIButton *forgetBtn;

- (id)initWithPayComple:(void(^)(PayActionType type,NSString *passwordStr))comple;

- (void)show;
- (void)hiddenAlert;

@end
