//
//  MHVolActivityDetailsMembersCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsMembersCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "MHVolSerTeamMember.h"

#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
@interface MHVolActivityDetailsMembersCell()
@property (strong, nonatomic) UILabel *titleLabel;


@property (nonatomic, strong) NSMutableArray  *btns;

@end


@implementation MHVolActivityDetailsMembersCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolActivityDetailsMembersCell";
    MHVolActivityDetailsMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
}


#pragma mark - setter
- (void)setMemberList:(NSArray<MHVolSerTeamMember *> *)memberList {
    _memberList = [memberList copy];
    [self initUI];
}


- (void)layoutSubviews{
    [super layoutSubviews];
}




#pragma mark - SetUI
- (void)initUI{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(24);
        make.right.equalTo(self.contentView).offset(-24);
        make.height.mas_equalTo(28);
    }];
    [self addMemberBtns];
}

- (void)addMemberBtns{
    CGFloat btnFirst_Y = 56 + 24;
    
    NSInteger length = _memberList.count ;
    if (length > 0) {
        for (int i = 0 ; i < length; i ++) {
            MHVolSerTeamMember *member = _memberList [i];
            UIButton * bt = [UIButton new];
            bt.tag = i ;
            [bt addTarget:self action:@selector(headerAvaAction:) forControlEvents:UIControlEventTouchUpInside];
            [bt sd_setImageWithURL:member.user_s_img forState:UIControlStateNormal placeholderImage:MAvatar];
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
            CGFloat leftMargin = 24 ;
            
            //  按钮之间的间距 =（总宽度 - 两边距 - 控件的宽度 * 个数）
            CGFloat margin = (MScreenW - leftMargin*2 - (totalColumns * answerW))/(totalColumns - 1);
            
            int col = i % totalColumns;
            // 按钮的x = 最左边的间距 + 列号 * (按钮宽度 + 按钮之间的间距)
            CGFloat answerX = leftMargin + col * (answerW + margin);
            
            int row = i / totalColumns;
            // 按钮的y = 行号 * (按钮高度 + 按钮之间的间距)
            CGFloat answerY = row * (answerH + margin) + btnFirst_Y;
            
            bt.frame = CGRectMake(answerX, answerY, answerW, answerH);
            CGRect  btnFrame = bt.frame ;
            bt.layer.cornerRadius = btnFrame.size.width*0.5  ;
            bt.layer.masksToBounds = YES ;
            [self.contentView addSubview:bt];
            //        [self.btns addObject:bt];
            if (i == length - 1) {
                CGFloat x = bt.mh_left;
                CGFloat y = bt.mh_top;
                [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(x);
                    make.top.equalTo(self.contentView).offset(y);
                    make.width.height.mas_equalTo(50);
                    make.bottom.equalTo(self.contentView).offset(- 24);
                }];
            }
        }
        
    }else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(24);
            make.right.bottom.equalTo(self.contentView).offset(-24);
            make.height.mas_equalTo(28);
        }];
    }
}


#pragma mark - Event
- (void)headerAvaAction:(UIButton *)bt{
    if (self.delegate && [self.delegate respondsToSelector:@selector(volSerMemberdidSelectItemWithModel:)]) {
        [self.delegate volSerMemberdidSelectItemWithModel:_memberList[bt.tag]];
    }
}


- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }return _btns;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = MColorToRGB(0X41526A);
        _titleLabel.font = [UIFont systemFontOfSize:20.0f weight:UIFontWeightMedium];
        _titleLabel.text = @"报名队员";
    }return _titleLabel ;
}

@end
