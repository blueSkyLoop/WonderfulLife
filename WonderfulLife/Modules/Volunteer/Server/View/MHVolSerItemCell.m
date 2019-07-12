//
//  MHVolSerItemCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerItemCell.h"
#import "MHMacros.h"

@interface MHVolSerItemCell ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation MHVolSerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layerView.layer.borderWidth = 1;
    self.layerView.layer.borderColor = MColorSeparator.CGColor;
    self.layerView.layer.cornerRadius = 6;
    
    self.layerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.layerView.layer.shadowRadius = 5;
    self.layerView.layer.shadowColor = MColorShadow.CGColor;
    self.layerView.layer.shadowOpacity = 1;
    self.layerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
