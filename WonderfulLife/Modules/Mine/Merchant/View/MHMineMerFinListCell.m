//
//  MHMineMerFinListCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/11/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinListCell.h"
#import "MHMineMerFinModel.h"
#import "UILabel+isNull.h"
#import "MHMacros.h"

@interface MHMineMerFinListCell()
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end


@implementation MHMineMerFinListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mh_configCellWithInfor:(MHMineMerFin_record *)model{

    [self.scoreLab mh_isNullText:model.change_amount];
    
    [self.timeLab mh_isNullText:model.change_time];
    
    NSString *symbolStr ;
    
    if ([model.change_type isEqualToNumber:@0]) {
        [self setStatusWithStatusLab:@"收入" textColor:MColorToRGB(0x13CE66)];
        symbolStr = @"+" ;
    }else if ([model.change_type isEqualToNumber:@1]) {
        [self setStatusWithStatusLab:@"提现" textColor:MColorToRGB(0x20A0FF)];
        symbolStr = @"-" ;
    }else if ([model.change_type isEqualToNumber:@2]) {
        [self setStatusWithStatusLab:@"退款" textColor:MColorToRGB(0xFF4949)];
        symbolStr = @"-" ;
    }
    
    [self.scoreLab mh_isNullWithDataSourceText:model.change_amount allText:[NSString stringWithFormat:@"%@%@",symbolStr,model.change_amount] isNullReplaceString:@""];
    
}

- (void)setStatusWithStatusLab:(NSString *)text textColor:(UIColor *)color{
    self.statusLab.text = text ;
    self.statusLab.textColor = color ;
}

@end
