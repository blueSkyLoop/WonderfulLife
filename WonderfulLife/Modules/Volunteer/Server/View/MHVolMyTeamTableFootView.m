//
//  MHVolMyTeamTableFootView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolMyTeamTableFootView.h"
#import <HLCategory/UIView+HLNib.h>
#import "MHMacros.h"

@interface MHVolMyTeamTableFootView ()
@property (weak, nonatomic) IBOutlet UIButton *mh_button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonToLabel;
@property (copy,nonatomic) MHVolTeamFootButtonCallBack callBack;
@end

@implementation MHVolMyTeamTableFootView

+ (instancetype)viewWithOutButton {
   MHVolMyTeamTableFootView *view = [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]
     instantiateWithOwner:self options:nil].firstObject;
    view.buttonToTop.constant = 0;
    view.buttonHeight.constant = 0;
    view.buttonToLabel.constant = 4;
    view.mh_button.hidden = YES;
    view.frame = CGRectMake(0, 0, MScreenW, 144);
    return view;
}

+ (instancetype)viewWithBtnTitle:(NSString *)text buttonAction:(MHVolTeamFootButtonCallBack)buttonAction{
    MHVolMyTeamTableFootView *view = [[UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]
                                      instantiateWithOwner:self options:nil].firstObject;
    view.buttonToTop.constant = 20;
    view.buttonHeight.constant = 56;
    view.buttonToLabel.constant = 16;
    [view.mh_button setTitleColor:MColorBlue forState:UIControlStateNormal];
    view.mh_button.layer.borderWidth = 1;
    view.mh_button.layer.borderColor = MColorBlue.CGColor;
    view.mh_button.layer.cornerRadius = 6;
    view.mh_button.hidden = NO;
    [view.mh_button setTitle:text forState:UIControlStateNormal];
    view.callBack = buttonAction;
    view.frame = CGRectMake(0, 0, MScreenW, 144); // height 之前是38 不知道为何
    return view;
}

- (IBAction)clickEvent:(id)sender {
    if (self.callBack) self.callBack();
}

@end
