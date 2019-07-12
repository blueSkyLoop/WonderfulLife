//
//  MHHomeCertificationView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeCertificationView.h"
#import "MHThemeButton.h"

#import "MHMacros.h"

#import <HLCategory/UIView+HLNib.h>

@interface MHHomeCertificationView ()
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet MHThemeButton *certificationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totopconstant;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *heightContants;

@property (copy,nonatomic) MHHomeCertificationAction action;
@end

@implementation MHHomeCertificationView

+ (instancetype)awakeFromNibWithCaetificationAction:(MHHomeCertificationAction)action {
    MHHomeCertificationView *view = [self hl_awakeFromNibName:NSStringFromClass([self class])];
    view.action = action;
    return [view setUp];
}


- (instancetype)setUp {
    self.frame = [UIScreen mainScreen].bounds;
    self.containView.layer.cornerRadius = 26;
    self.certificationButton.layer.cornerRadius = CGRectGetHeight(self.certificationButton.frame)/2;
    self.certificationButton.noShadow = YES;
    
    for (NSLayoutConstraint *constraint in self.heightContants)
        constraint.constant *= MScreenH/667.0;
    if (isIPhone5()||isIPhone4()) {
       self.totopconstant.constant = 20;
    } 
    return self;
}

- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)certificationAction:(id)sender {
    if (self.action) self.action();
    [self removeFromSuperview];
}


@end
