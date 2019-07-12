//
//  MHActivityStausView.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHActivityStatusView.h"
#import "UIView+Shadow.h"
#import "MHMacros.h"
#import "MHThemeButton.h"
@interface MHActivityStatusView()
@property (weak, nonatomic) IBOutlet MHThemeButton *doneBtn;

@end

@implementation MHActivityStatusView

+ (instancetype)activityViewWithStatus:(MHActivityStatusViewType)type actionBlock:(ActionHandler)actionHandler{
    MHActivityStatusView *View = [MHActivityStatusView loadNormalAlertView];
    View.type = type;
    View.actionHandler = actionHandler ;
    if (type == MHActivityStatusViewTypeGoing) {
        [View disabledBtnTitle:@"活动进行中"];
    }else if (type == MHActivityStatusViewTypeEnd){
        [View disabledBtnTitle:@"活动已结束"];
    }else if (type == MHActivityStatusViewTypeCancel){
        [View disabledBtnTitle:@"活动已取消"];
    }else if (type == MHActivityStatusViewTypeManagement){
        [View normalBtnTitle:@"活动管理"];
    }else if (type == MHActivityStatusViewTypeRelease){
        [View normalBtnTitle:@"发布活动"];
    }
    return View;
}




/**  普通可点击状态*/
- (void)normalBtnTitle:(NSString *)title{
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

/** 禁止点击状态*/
- (void)disabledBtnTitle:(NSString *)title{
    self.doneBtn.enabled = NO;
    [self.doneBtn setTitleColor:MColorToRGB(0x717F95) forState:UIControlStateNormal];
    [self.doneBtn setBackgroundColor:MColorToRGB(0x717F95)];
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

- (IBAction)action:(id)sender {
    if (self.actionHandler) {
        self.actionHandler();
    }
}


/**
 加载默认样式中间提醒框
 */
+ (instancetype)loadNormalAlertView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


@end
