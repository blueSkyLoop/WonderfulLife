//
//  MHMineMerWithdrawFinanceReocrdHeadView.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawFinanceReocrdHeadView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "LCommonModel.h"

@implementation MHMineMerWithdrawFinanceReocrdHeadView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    bgView.backgroundColor = MRGBColor(249,250,252);
    self.backgroundView = bgView;
    [self.contentView addSubview:self.financeTitleLabel];
    [_financeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-16).priorityHigh();
    }];
}
#pragma mark - lazyload
- (UILabel *)financeTitleLabel{
    if(!_financeTitleLabel){
        _financeTitleLabel = [LCommonModel quickCreateLabelWithFont:MHWFont(20) textColor:MRGBColor(50, 64, 87)];
        _financeTitleLabel.text = @"提现金额流水";
    }
    return _financeTitleLabel;
}

@end
