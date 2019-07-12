//
//  MHHomeItemCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeItemCell.h"

#import "MHMacros.h"

@interface MHHomeItemCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toleftConstant;
@end

@implementation MHHomeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (MScreenW == 320) {
        self.toleftConstant.constant = 10;
    } else {
        self.toleftConstant.constant = 24;
    }
    
}

- (void)mh_collectionViewCellWithModel:(NSDictionary*)model {
    self.mh_imageView.image = [UIImage imageNamed:model[@"imageUrl"]];
    self.mh_label.text = model[@"title"];
    self.mh_subLabel.text = model[@"subtitle"];
}

@end
