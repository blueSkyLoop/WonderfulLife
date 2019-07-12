//
//  MHStoreRefundHeaderView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundHeaderView.h"
#import "MHMacros.h"
#import "LCommonModel.h"
#import "Masonry.h"

@implementation MHStoreRefundHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        //背景颜色
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 60)];
        bgView.backgroundColor = MColorBackgroud;
        self.backgroundView = bgView;
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.instructionLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [_instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-16);
        }];
        
        
        
    }
    return self;
}

#pragma mark - lazyload
- (UILabel *)nameLabel{
    if(!_nameLabel){
        UIFont *afont ;
        if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
            afont = [UIFont systemFontOfSize:MScale * 17 weight:UIFontWeightSemibold];
        }else{
            afont = [UIFont boldSystemFontOfSize:MScale * 17];
        }
        _nameLabel = [LCommonModel quickCreateLabelWithFont:afont textColor:MRGBColor(50, 64, 87)];
    }
    return _nameLabel;
}
- (UILabel *)instructionLabel{
    if(!_instructionLabel){
        _instructionLabel = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MRGBColor(252, 62, 91)];
    }
    return _instructionLabel;
}

@end
