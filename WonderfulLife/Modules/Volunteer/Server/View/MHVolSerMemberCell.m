//
//  MHVolSerMemberCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerMemberCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "MHVolSerTeamMember.h"

#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
@interface MHVolSerMemberCell ()
@end


@implementation MHVolSerMemberCell



#pragma mark - setter
- (void)setMemberLiat:(NSArray<MHVolSerTeamMember *> *)memberLiat {
    _memberLiat = [memberLiat copy];
    [self initUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self initUI];
}

#pragma mark - SetUI
- (void)initUI{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger length = _memberLiat.count ;
    for (int i = 0 ; i < length; i ++) {
        MHVolSerTeamMember *member = _memberLiat [i];
        UIButton * bt = [UIButton new];
        bt.tag = i ;
        [bt addTarget:self action:@selector(headerAvaAction:) forControlEvents:UIControlEventTouchUpInside];
        [bt sd_setImageWithURL:member.member_icon forState:UIControlStateNormal placeholderImage:MAvatar];

        // 按钮的尺寸
        CGFloat answerW = 50;
        CGFloat answerH = 50;
        
        // 总列数
        int totalColumns  ;
        if (isIPhone5()) {
            totalColumns = 4;
        }else{
            totalColumns = 5;
        }
        
        // (32*2)  控件距离屏幕的边距
        CGFloat leftMargin = 32 ;
        
        //  按钮之间的间距 =（总宽度 - 两边距 - 控件的宽度 * 个数）
        CGFloat margin = (MScreenW - leftMargin*2 - (totalColumns * answerW))/(totalColumns - 1);

        int col = i % totalColumns;
        // 按钮的x = 最左边的间距 + 列号 * (按钮宽度 + 按钮之间的间距)
        CGFloat answerX = leftMargin + col * (answerW + margin);
        
        int row = i / totalColumns;
        // 按钮的y = 行号 * (按钮高度 + 按钮之间的间距)
        CGFloat answerY =  17 + row * (answerH + margin);
        
        bt.frame = CGRectMake(answerX, answerY, answerW, answerH);
        CGRect  btnFrame = bt.frame ;
        bt.layer.cornerRadius = btnFrame.size.width*0.5  ;
        bt.layer.masksToBounds = YES ;
        [self.contentView addSubview:bt];
        
        if (i == length - 1) {
            CGFloat x = bt.mh_left;
            CGFloat y = bt.mh_top;
            [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.top.mas_equalTo(y);
                make.width.height.mas_equalTo(50);
                make.bottom.equalTo(self.contentView).offset(- 24);
            }];
        }
    }
}

#pragma mark - Event
- (void)headerAvaAction:(UIButton *)bt{
    if (self.delegate && [self.delegate respondsToSelector:@selector(volSerMemberdidSelectItemWithModel:)]) {
        [self.delegate volSerMemberdidSelectItemWithModel:_memberLiat[bt.tag]];
    }
}

@end
