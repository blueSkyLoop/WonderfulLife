//
//  MHStorePictureCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStorePictureCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "MHStoreGoodsDetailModel.h"

@implementation MHStorePictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.pictureView.collectionView.scrollEnabled = NO;
}

- (void)mh_configCellWithInfor:(MHStoreGoodsDetailModel *)model{
    self.adescriptionLabel.text = model.remark;
    NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:model.img_list.count];
    NSMutableArray *bigPicArr = [NSMutableArray arrayWithCapacity:model.img_list.count];
    for(int i=0;i<model.img_list.count;i++){
        MHStoreGoodsImageModel *picModel = model.img_list[i];
        [picArr addObject:picModel.s_url?:@""];
        [bigPicArr addObject:picModel.url?:@""];
    }
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.pictureView.collectionView.collectionViewLayout;
    if(picArr.count){
        CGFloat width = layout.itemSize.width;
        CGFloat gap = layout.minimumLineSpacing;
        if(picArr.count % 3 == 0){
            NSInteger line = picArr.count / 3;
            self.picHeightLayout.constant =  line * width + (line - 1) * gap;
        }else{
            NSInteger line = picArr.count / 3 + 1;
            self.picHeightLayout.constant =  line * width + (line - 1) * gap;
        }
    }else{
        self.picHeightLayout.constant = 0;
    }
    
    self.pictureView.picArr = [picArr mutableCopy];
    self.pictureView.bigPicArr = [bigPicArr mutableCopy];
    
}

@end
