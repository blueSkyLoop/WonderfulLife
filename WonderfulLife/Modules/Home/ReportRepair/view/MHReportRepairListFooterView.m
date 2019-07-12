//
//  MHReportRepairListFooterView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListFooterView.h"
#import "MHMacros.h"
#import "ReactiveObjC.h"
#import "Masonry.h"

@implementation MHReportRepairListFooterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    [self addSubview:self.button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (MHThemeButton *)button{
    if(!_button){
        _button = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 60)];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_button setBackgroundColor:MRGBColor(229, 233, 242)];
        [_button setImage:[UIImage imageNamed:@"ReportRepair_add"] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:MScale * 19];
        [_button setTitle:@" 新增" forState:UIControlStateNormal];
        _button.layer.cornerRadius = 0;
        _button.layer.masksToBounds = NO;
        
    }
    return _button;
}
@end
