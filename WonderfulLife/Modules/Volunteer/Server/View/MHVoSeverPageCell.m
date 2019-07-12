//
//  MHVoSeverPageCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeverPageCell.h"
#import "MHVolSerPageFuncConstruct.h"

@implementation MHVoSeverPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)mh_configCellWithInfor:(MHVoServerFunctiomModel *)model{
    if(model.imageName){
        self.iconImageView.image = [UIImage imageNamed:model.imageName];
    }else{
        self.iconImageView.image = nil;
    }
    self.nameLabel.text = model.title;
}

@end
