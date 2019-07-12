//
//  MHReportRepairPictreCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairPictreCell.h"
#import "UIImageView+WebCache.m"
#import "MHMacros.h"

@interface MHReportRepairPictreCell()

@property (nonatomic,strong)MHReportRepairPictureModel *model;

@end

@implementation MHReportRepairPictreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)mh_configCellWithInfor:(MHReportRepairPictureModel *)model{
    
    self.model = model;
    
    if(model.isTakePhoto){
        self.closeButton.hidden = YES;
        self.pictureView.image = [UIImage imageNamed:@"ReportRepair_picture_add"];
    }else{
        if(model.image){
            self.pictureView.image = model.image;
        }else{
            if([model.pictreUrlStr hasPrefix:@"http"]){
                [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.pictreUrlStr] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
            }else{
                self.pictureView.image = [UIImage imageNamed:model.pictreUrlStr];
            }
        }
        self.closeButton.hidden = NO;
    }
    
}
- (IBAction)closeAction:(UIButton *)sender {
    if(self.pictureCloseBlock){
        __weak __typeof(self)weakSelf = self;
        self.pictureCloseBlock(weakSelf.model);
    }
}

@end
