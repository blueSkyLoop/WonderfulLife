//
//  MHVolActivityDetailsHeaderView.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsHeaderView.h"
#import "MHVolActivityDetailsModel.h"
#import "Masonry.h"
@interface MHVolActivityDetailsHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIView *line;

@end


@implementation MHVolActivityDetailsHeaderView


+ (instancetype)activityDetailsHeaderView:(MHVolActivityDetailsModel *)model{
    MHVolActivityDetailsHeaderView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self)  owner:nil options:nil].lastObject;
    view.teamNameLB.text = model.team_name ;
//     action_type	Integer	0|1|2	活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
    if (model.action_type == 0) {
        /*
        [view.teamNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(24);
            make.right.mas_equalTo(-24);
            make.height.mas_equalTo(25);
        }];
        
        
        [view.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.teamNameLB.mas_bottom).offset(24);
            make.left.mas_equalTo(24);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-24);
            make.height.mas_equalTo(0.5);
        }];
        */
        view.imageIcon.hidden = YES ;
        CGRect frame = view.frame ;
        frame.size.height -= 50;
        view.frame = frame ;
    }
    
    
    return view;
}

@end
