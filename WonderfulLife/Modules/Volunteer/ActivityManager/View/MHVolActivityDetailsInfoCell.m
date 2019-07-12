//
//  MHVolActivityDetailsInfoCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsInfoCell.h"
#import "YYLabel.h"
#import "YYText.h"
#import "Masonry.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
#import "MHVolActivityDetailsModel.h"
#import "MHVolSerCaptainModel.h"
#import "NSObject+isNull.h"
#import "UILabel+isNull.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MHVolActivityDetailsInfoCell()
@property (weak, nonatomic) IBOutlet YYLabel *capLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *pointLB;
@property (weak, nonatomic) IBOutlet UILabel *personCount;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@property (weak, nonatomic) IBOutlet UIImageView *captainIcon;
@property (weak, nonatomic) IBOutlet UIImageView *checkTimeIcon;

@end


@implementation MHVolActivityDetailsInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolActivityDetailsInfoCell";
    MHVolActivityDetailsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect  imageFrame = self.icon.frame ;
    self.icon.layer.cornerRadius = imageFrame.size.width*0.5  ;
    self.icon.layer.masksToBounds = YES ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIcon:)];
    [self.icon addGestureRecognizer:tap];
}


- (void)setModel:(MHVolActivityDetailsModel *)model{
    _model = model;
    
    if (![NSObject isNull:model.captain.captain_name]) {
        [self.icon sd_setImageWithURL:model.captain.user_s_img placeholderImage:MAvatar];
        NSString *allText =[NSString stringWithFormat:@"队长：%@",model.captain.captain_name];
        NSRange range = [allText rangeOfString:model.captain.captain_name];
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:allText];
        text.yy_lineSpacing = 5;
        text.yy_font = [UIFont systemFontOfSize:18];
        text.yy_color = MColorTitle;
        MHWeakify(self)
        [text yy_setTextHighlightRange:range color:MColorBlue backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            MHStrongify(self)
            [self delegateAction];
            NSLog(@"xxx协议被点击了");
            
        }];
        self.capLB.attributedText = text;  //设置富文本
        self.captainIcon.hidden = NO;
        self.capLB.hidden = NO;
        self.icon.hidden = NO;
        
        [self.captainIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(24);
            make.top.equalTo(self.contentView).offset(31);
            make.width.height.mas_offset(14);
        }];
        [self.checkTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(24);
            make.top.equalTo(self.captainIcon.mas_bottom).offset(23);
            make.width.height.mas_offset(14);
        }];
        
    }else{
        self.captainIcon.hidden = YES;
        self.capLB.hidden = YES;
        self.icon.hidden = YES;
        
        [self.checkTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(24);
            make.top.equalTo(self.contentView).offset(31);
            make.width.height.mas_offset(14);
        }];
        
    }
    
    [self.pointLB mh_isNullWithDataSourceText:model.score_rule_method allText:[NSString stringWithFormat:@"积分：%@",model.score_rule_method] isNullReplaceString:@"积分：暂无积分"];
    
    [self.timeLB mh_isNullWithDataSourceText:model.times allText:[NSString stringWithFormat:@"时长：%@",model.times] isNullReplaceString:@"时长："];
    
    NSString *personCount = [NSString stringWithFormat:@"%ld人",model.qty];
    if (model.qty == 0) {
        personCount = @"不限";
    }
    self.personCount.text = [NSString stringWithFormat:@"名额：%@",personCount];
    
}

- (void)tapIcon:(UITapGestureRecognizer *)sender{
    [self delegateAction];
}

- (void)delegateAction{
    if ([self.delegate respondsToSelector:@selector(InfoCellDidClickIcon:)]) {
        [self.delegate InfoCellDidClickIcon:nil];
    }
}

@end
