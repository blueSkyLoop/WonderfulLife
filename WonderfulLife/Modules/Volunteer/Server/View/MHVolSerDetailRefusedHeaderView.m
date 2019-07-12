//
//  MHVolSerDetailRefusedHeaderView.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerDetailRefusedHeaderView.h"
#import "MHMacros.h"
#import "UILabel+HLLineSpacing.h"
#import "NSObject+isNull.h"
@interface MHVolSerDetailRefusedHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end


@implementation MHVolSerDetailRefusedHeaderView


+ (instancetype)refusedHeaderViewWithReason:(NSString *)reason title:(NSString *)title{
    MHVolSerDetailRefusedHeaderView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject ;
    view.contentView.layer.borderWidth = 1;
    view.contentView.layer.borderColor = MColorSeparator.CGColor;
    view.contentView.layer.cornerRadius = 6;
    
    
    view.titleLB.text = title;
    
    NSString *text ;
    if ([NSObject isNull:reason]) {
        text = @"";
    }else{
        text = reason;
    }
    
    view.content.text = [NSString stringWithFormat:@"原因：%@",text] ;
    [view.content hl_setLineSpacing:10.0 text:view.content.text];
    [view.content sizeToFit];
    
    // 文本高度
    CGRect contentLBFrame = view.content.frame ;
    CGFloat lb_H = [UILabel hl_heightWithlineSpacing:25.0 text:view.content.text fontSize:10.0 width:contentLBFrame.size.width];
    
    contentLBFrame.size.height = lb_H ;
    view.content.frame = contentLBFrame;
    
    
    // contentView frame
    CGRect contentViewFrame = view.contentView.frame;
    contentViewFrame.size.height = CGRectGetMidY(view.content.frame) + lb_H + 16;
    view.contentView.frame = contentViewFrame ;
    
    
    CGRect viewFrame = view.frame ;
    viewFrame.size.height = CGRectGetMaxY(view.contentView.frame) + 40 ;
    view.frame = viewFrame;
    
    return view;
}


@end
