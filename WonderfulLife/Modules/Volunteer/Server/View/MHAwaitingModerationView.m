//
//  MHAwaitingModerationView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAwaitingModerationView.h"
#import "UIView+HLNib.h"
#import "MHMacros.h"

@interface MHAwaitingModerationView ()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;

@end

@implementation MHAwaitingModerationView

+ (instancetype)awakeFromNib:(MHAwaitingModerationViewResultType)type{
    MHAwaitingModerationView *view = [MHAwaitingModerationView hl_awakeFromNibName:NSStringFromClass([self class])];
    view.lineView.layer.borderWidth = 1;
    view.lineView.layer.borderColor = MColorSeparator.CGColor;
    view.lineView.layer.cornerRadius = 6;
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
    
    NSString *title ;
    NSString *content ;
    
    if (type == MHAwaitingModerationViewResultTypAwaiting) {
        title = @"申请等待审核中";
        content = @"请留意电话或短信";
        
    }else if ( type == MHAwaitingModerationViewResultTypeLeave){
        title = @"已退出";
        content = @"不可重新申请加入";
    }
    view.titleLB.text = title ;
    view.contentLB.text = content;
    
    
    
    return view;
}

@end
