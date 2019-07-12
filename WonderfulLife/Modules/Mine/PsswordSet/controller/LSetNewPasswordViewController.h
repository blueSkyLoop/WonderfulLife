//
//  LSetNewPasswordViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"
#import "MHNavigationControllerManager.h"

typedef NS_ENUM(NSInteger,PayPasswordSetType) {
    PayPassword_set,
    PayPassword_reset
};

@interface LSetNewPasswordViewController : MHBaseViewController<MHNavigationControllerManagerProtocol>

@property (nonatomic,assign)PayPasswordSetType setNewPasswordType;

// PayPassword_reset 设置新的密码   PayPassword_set 设置密码（第一次）
- (id)initWithSetType:(PayPasswordSetType)asetNewPassword;

@end
