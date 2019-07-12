//
//  MHLoSelectPlotFootView.m
//  WonderfulLife
//
//  Created by zz on 01/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHLoSelectPlotFootView.h"
#import "MHMacros.h"
#import "ReactiveObjC.h"

@interface MHLoSelectPlotFootView()
@property (weak, nonatomic) IBOutlet UILabel *footTipsLable;

@end

@implementation MHLoSelectPlotFootView

+ (instancetype)initDefaultFootView {
    MHLoSelectPlotFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"MHLoSelectPlotFootView" owner:nil options:nil] objectAtIndex:0];
    for (UIView *view in footView.subviews) {
        if (view.tag == 7901) {
            UILabel *tipsLabel = (UILabel *)view;
            [tipsLabel setTextColor:MColorContent];
        }
    }
    return footView;
}

+ (instancetype)initFootViewWithUserDefineButton:(AddressUserDefinedBlock)block{
    MHLoSelectPlotFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"MHLoSelectPlotFootView" owner:nil options:nil] objectAtIndex:1];
    for (UIView *view in footView.subviews) {
        if (view.tag == 7902) {
            UIButton *btn = (UIButton *)view;
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                block();
            }];
        }
    }
    return footView;
}

+ (instancetype)initFootViewWithExperienceCommunityButton:(AddressUserDefinedBlock)block{
    MHLoSelectPlotFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"MHLoSelectPlotFootView" owner:nil options:nil] objectAtIndex:2];
    for (UIView *view in footView.subviews) {
        if (view.tag == 7903) {
            UIButton *btn = (UIButton *)view;
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                block();
            }];
        }
    }
    return footView;
}

+ (instancetype)initFootViewWithNoDatasExperienceCommunityButton:(AddressUserDefinedBlock)block{
    MHLoSelectPlotFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"MHLoSelectPlotFootView" owner:nil options:nil] objectAtIndex:3];
    for (UIView *view in footView.subviews) {
        if (view.tag == 7903) {
            UIButton *btn = (UIButton *)view;
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                block();
            }];
        }
    }
    return footView;
}

@end
