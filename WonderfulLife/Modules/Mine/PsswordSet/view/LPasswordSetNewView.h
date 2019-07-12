//
//  LPasswordSetNewView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "LPasswordView.h"

@interface LPasswordSetNewView : UIView

@property (nonatomic,strong)UILabel *atitleLable;
@property (nonatomic,strong)LPasswordView *inputBgView;
@property (nonatomic,strong)LPasswordView *reInputBgView;


@property (nonatomic,copy)NSString *payPassword;

- (void)clearAllInput;

@end
