//
//  MHHomePayDetailsHeaderView.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayDetailsHeaderView.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHHomePayDetailsHeaderView ()


@end

@implementation MHHomePayDetailsHeaderView{

}
/**
 加载物业缴费头部视图
 */
+ (instancetype)loadHomePayDetailsHeaderView {
    MHHomePayDetailsHeaderView *headerView = [MHHomePayDetailsHeaderView new];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = MFont(34);
    titleLabel.textColor = MColorTitle;
    titleLabel.text = @"缴费详情";
    [headerView addSubview:titleLabel];
    headerView.titleLabel = titleLabel;
    
    UIView *line = [UIView new];
    line.backgroundColor = MRGBColor(211, 220, 231);
    [headerView addSubview:line];
    headerView.bottomLine = line;
    return headerView;
}

- (void)layoutSubviews{
    [self.titleLabel sizeToFit];
    self.titleLabel.nim_centerX = self.nim_width/2;
    self.bottomLine.nim_width = self.nim_width;
    self.bottomLine.nim_height = 1;
    self.bottomLine.nim_top = self.nim_height - 1;
}
@end
