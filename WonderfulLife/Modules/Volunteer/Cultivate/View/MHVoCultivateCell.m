//
//  MHVoCultivateCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoCultivateCell.h"
#import "MHVoCultivateModel.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
@interface MHVoCultivateCell ()

@property (nonatomic,strong) UIView *topLine;
@end

@implementation MHVoCultivateCell{
    CGFloat labelX;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] init];
        self.label.font = MFont(20*MScreenW/375);
        self.label.textColor = MColorTitle;
        labelX = 24*MScreenW/375;
        
        [self.contentView addSubview:self.label];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = MRGBColor(211, 220, 230);
        [self.contentView addSubview:_topLine];
    }
    return self;
}

- (void)setModel:(MHVoCultivateModel *)model{
    _model = model;
    self.label.text = model.category_name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.label sizeToFit];
    self.label.nim_left = labelX;
    self.label.nim_centerY = self.nim_height/2;
    
    _topLine.nim_size = CGSizeMake(self.nim_width, 0.5);
}

@end





