//
//  LFindPasswordView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "LPasswordView.h"
#import "MHThemeButton.h"

@interface LFindPasswordView : UIView
@property (nonatomic,strong)UILabel *atitleLable;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *suggestMessageLabel;
@property (nonatomic,strong)UILabel *frontNumLabel;
@property (nonatomic,strong)LPasswordView *inputBgView;
@property (nonatomic,strong)UIView *codeBgView;
@property (nonatomic,strong)UIImageView *signView;
@property (nonatomic,strong)UITextField *codeTextF;
@property (nonatomic,strong)UIButton *cuntDownBtn;
@property (nonatomic,strong)MHThemeButton *sureBtn;

@property (nonatomic,strong)RACSubject *codeGetSubject;
@property (nonatomic,strong)RACSubject *codeValiteSubject;


- (void)createTimer;


@end
