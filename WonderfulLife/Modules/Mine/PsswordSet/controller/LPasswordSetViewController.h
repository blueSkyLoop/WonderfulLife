//
//  LPasswordSetViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseViewController.h"

typedef  NS_ENUM(NSInteger,PasswordSetType){
    PasswordSet = 1,                //设置密码
    PasswordReSet                   //重置密码
};

@interface LPasswordSetViewController : MHBaseViewController

@property (nonatomic,assign)PasswordSetType type;

- (id)initWithPasswordSetType:(PasswordSetType)type;

@end
