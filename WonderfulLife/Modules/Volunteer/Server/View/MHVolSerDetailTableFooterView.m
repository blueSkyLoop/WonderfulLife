//
//  MHVolSerDetailTableFooterView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerDetailTableFooterView.h"

#import "MHThemeButton.h"
#import "MHMacros.h"
#import "UIImage+Color.h"

#import <UIView+HLNib.h>

@interface MHVolSerDetailTableFooterView ()
@property (weak, nonatomic) IBOutlet MHThemeButton *themeButton;
@property (copy,nonatomic) MHVolSerDetailFootButtonCallBack callBack;
@end

@implementation MHVolSerDetailTableFooterView

+ (instancetype)awakeFromNibWithButtonEvent:(MHVolSerDetailFootButtonCallBack)buttonEvent {
    MHVolSerDetailTableFooterView *view = [MHVolSerDetailTableFooterView hl_awakeFromNibName:NSStringFromClass([self class])];
    view.callBack = buttonEvent;
    view.frame = CGRectMake(0, 0, MScreenW, 110);
    return view;
}
- (IBAction)clickEvent:(id)sender {
    if (self.callBack) self.callBack();
}


+ (instancetype)awakeFromNibExitWithBtnTitle:(NSString *)title buttonEvent:(MHVolSerDetailFootButtonCallBack)buttonEvent{
    MHVolSerDetailTableFooterView *view = [MHVolSerDetailTableFooterView hl_awakeFromNibName:NSStringFromClass([self class])];
    view.callBack = buttonEvent;
    [view.themeButton setTitle:title forState:UIControlStateNormal];
    [view.themeButton setBackgroundColor:[UIColor whiteColor]];
    view.themeButton.layer.masksToBounds = YES;
    view.themeButton.layer.cornerRadius = 5;
    view.themeButton.layer.borderWidth = .5;
    view.themeButton.layer.borderColor = MColorSeparator.CGColor ;
    view.themeButton.backgroundColor = [UIColor whiteColor];
    [view.themeButton setTitleColor:MColorTitle forState:UIControlStateNormal];
    
    
    [view.themeButton setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [view.themeButton setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    [view.themeButton setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    
    [view.themeButton setNoShadow:YES];
    view.frame = CGRectMake(0, 0, MScreenW, 110);
    return view;
}

@end
