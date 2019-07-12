//
//  MHMineMerRegisterAlterView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerRegisterAlterView.h"
#import "UIView+Shadow.h"
#import "MHThemeButton.h"
#import "YYLabel.h"
#import "YYLabel+Category.h"
#import "NSObject+isNull.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
@interface MHMineMerRegisterAlterView ()

@property (weak, nonatomic) IBOutlet MHThemeButton *doneBtn;

@property (nonatomic, copy)   RegisterAlterBlock  attBlcok;

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet YYLabel *conentLab;
@property (nonatomic, assign) MHMineMerRegisterAlterViewType type;

@property (nonatomic, copy)   NSString * attribut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layerViewCons_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layerViewCons_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneCons_bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneCon_H;

@end
@implementation MHMineMerRegisterAlterView{
    CGFloat scale;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    scale = MScreenW/375;
}
+ (instancetype)mineMerRegisterAlterView {
    MHMineMerRegisterAlterView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MHMineMerRegisterAlterView class]) owner:nil options:nil].lastObject ;
    
    return view ;
}




+ (instancetype)mineMerRegisterAlterViewWithFrame:(CGRect)frame
                                          Content:(NSString *)content
                                         Attribut:(NSString *)attribut
                                          TipType:(MHMineMerRegisterAlterViewType)type
                                  AttributedBlock:(RegisterAlterBlock)attBlcok{
    MHMineMerRegisterAlterView * view = [MHMineMerRegisterAlterView mineMerRegisterAlterView];
    view.frame = frame ;
    view.attBlcok = attBlcok ;
    view.type = type ;
    view.conentLab.text = content ;
    view.attribut = attribut ;

    [view setConfig];
    
    return view ;
}

- (void)setConfig {

    self.layerView.layer.cornerRadius = 6;
    self.layerView.layer.borderColor = MColorSeparator.CGColor;
    self.layerView.layer.borderWidth = 0.5;
    
    self.conentLab.numberOfLines =  0 ;
    
    if (![NSObject isNull:self.attribut]) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.conentLab.text];
        NSRange attRange = [self.conentLab.text rangeOfString:self.attribut];
        att.yy_color = MColorToRGB(0x475669);
        MHWeakify(self)
        [att yy_setTextHighlightRange:attRange color:MColorBlue backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            MHStrongify(self)
            if (self.attBlcok) self.attBlcok(self);
            [self remove];
        }];
        self.conentLab.attributedText = att;
        [self.conentLab mh_changeAttributedStringLineWithSpace:10];
    }else {
        [self.conentLab mh_changeLineWithSpace:10];
    }
    self.conentLab.font =  MFont(18*scale);
    self.conentLab.textAlignment = NSTextAlignmentCenter ;
    [self.conentLab sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layerViewCons_Top.constant = 72 * scale ;
    if (isIPhone5()) {
        self.layerViewCons_H.constant = 0.001;
        
        [self.doneBtn.titleLabel setFont:MFont(19*scale)];
        self.doneCon_H.constant = 56 * scale ;
    }
    [self layoutIfNeeded];
}


- (IBAction)clearBtnAction:(id)sender {
    [self remove];
}

- (void)remove {
    [self removeFromSuperview];
}


- (IBAction)knowAction:(id)sender {
    [self remove];
}


@end
