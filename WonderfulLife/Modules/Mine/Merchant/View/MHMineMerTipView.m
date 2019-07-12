//
//  MHMineMerTipView.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerTipView.h"
#import "UIView+Shadow.h"
#import "MHThemeButton.h"
#import "YYLabel.h"
#import "YYLabel+Category.h"
#import "NSObject+isNull.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
@interface MHMineMerTipView ()
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet MHThemeButton *doSometineBtn;



@property (nonatomic,copy) tipViewDoSomeThing block;
@property (nonatomic, copy)   attributedBlock  attBlcok;

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet YYLabel *conentLab;
@property (nonatomic, assign) MHMineMerTipViewType type;

@property (nonatomic, copy)   NSString * attribut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layerViewCons_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layerViewCons_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knowBtnCons_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dostBtnCon_H;


@end

@implementation MHMineMerTipView{
    CGFloat scale;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    scale = MScreenW/375;
}

+ (instancetype)mineMerTipView {
    MHMineMerTipView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MHMineMerTipView class]) owner:nil options:nil].lastObject ;

    return view ;
}


+ (instancetype)mineMerTipViewWithFrame:(CGRect)frame
                                Content:(NSString *)content
                               Attribut:(NSString *)attribut
                                TipType:(MHMineMerTipViewType)type
                           DostBtnTitle:(NSString *)btntitle
                     TipViewDoSomeThing:(tipViewDoSomeThing)blcok
                        AttributedBlock:(attributedBlock)attBlcok{
    
    MHMineMerTipView * view = [MHMineMerTipView mineMerTipView];
    view.frame = frame ;
    view.block = blcok ;
    view.attBlcok = attBlcok ;
    view.type = type ;
    view.conentLab.text = content ;
    view.attribut = attribut ;
     [view.doSometineBtn setTitle:btntitle forState:UIControlStateNormal];
    
    [view setConfig];
    
    return view ;
}


- (void)setConfig {
    [self.knowBtn mh_setupContainerLayerWithContainerView];
//    [self.layerView mh_setupContainerLayerWithContainerView];
    
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
        self.dostBtnCon_H.constant = 56 * scale ;
        
        [self.doSometineBtn.titleLabel setFont:MFont(19*scale)];
        [self.knowBtn.titleLabel setFont:MFont(19*scale)];

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


- (IBAction)doSomeThingAction:(id)sender {
    if (self.block) self.block(self);
    [self remove];
}

@end
