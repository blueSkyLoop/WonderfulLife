//
//  MHActivityModifyContainerView.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyContainerView.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"

@implementation MHActivityModifyContainerView

+ (instancetype)initSection0View:(NSString*)title {
    MHActivityModifyContainerView *view = [[[NSBundle mainBundle] loadNibNamed:@"MHActivityModifyContainerView" owner:nil options:nil] objectAtIndex:0];
   
    for (UIView *subView in view.subviews) {
        if (subView.tag == 1096) {
            UILabel *tipsLabel = (UILabel *)subView;
            tipsLabel.text = title;
        }
    }
    return view;
}

+ (instancetype)initSection1View {
    MHActivityModifyContainerView *view = [[[NSBundle mainBundle] loadNibNamed:@"MHActivityModifyContainerView" owner:nil options:nil] objectAtIndex:1];
    return view;
}

+ (instancetype)initSectionPublishView:(NSString*)title block:(void (^)(void))block{
    MHActivityModifyContainerView *view = [[[NSBundle mainBundle] loadNibNamed:@"MHActivityModifyContainerView" owner:nil options:nil] objectAtIndex:2];
    
    for (UIView *subView in view.subviews) {
        if (subView.tag == 1097) {
            UIButton *btn = (UIButton *)subView;
            btn.layer.cornerRadius = 6;
            btn.layer.borderColor = MColorSeparator.CGColor;
            btn.layer.borderWidth = 0.5;
            
            btn.layer.shadowOffset = CGSizeMake(0, 2);
            btn.layer.shadowRadius = 5;
            btn.layer.shadowColor = MColorShadow.CGColor;
            btn.layer.shadowOpacity = 1;
            btn.layer.backgroundColor = [UIColor whiteColor].CGColor;
            [btn setTitle:title forState:UIControlStateNormal];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                block();
            }];
        }
    }
    return view;
}


@end
