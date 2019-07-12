//
//  MHReportRepairDetailCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"

@implementation MHReportRepairDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [LCommonModel resetFontSizeWithView:self];
    CGFloat height = MScreenW - 16 * 2 - 2 * 12;
    height = height / 3.0;
    self.picHeightLayout.constant = height;
    
    self.pictureView.itemSize = CGSizeMake(height, height);
    self.pictureView.itemGap = 12;
    self.pictureView.needShowTakePhoto = NO;
    self.pictureView.needShowCloseButton = NO;
    
    self.pictureView.backgroundColor = [UIColor whiteColor];
    
}

- (void)mh_configCellWithInfor:(MHReportRepairDetailModel *)model{

    if(!model.img_info_dtos || model.img_info_dtos.count == 0){
        self.picHeightLayout.constant = 0;
        self.picLayout.constant = 0;
    }else{
        self.picLayout.constant = 12;
        CGFloat height = MScreenW - 16 * 2 - 2 * 12;
        height = height / 3.0;
        self.picHeightLayout.constant = height;
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:model.img_info_dtos.count];
        for(int i=0;i<model.img_info_dtos.count;i++){
            MHReportRepairInforModel *tempModel = model.img_info_dtos[i];
            NSString *urlStr = tempModel.s_url?:tempModel.url;
            urlStr = urlStr?:@"";
            [muArr addObject:urlStr];
        }
        self.pictureView.pictureArr = [muArr copy];
    }
    self.contentLabel.text = model.repairment_cont;
    self.titleLabel.text = model.category_name;
    self.addressLabel.text = model.room?:@" ";
    self.nameLabel.text = model.contact_man;
    self.telLabel.text = model.contact_tel;
}

@end
