//
//  MHHomeButtonCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeButtonCell.h"
#import "MHMacros.h"
#import "MHHomeFunctionalModulesModel.h"
#import "UIImageView+WebCache.h"

@implementation MHHomeButtonCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath homeButtonType:(MHHomeButtonType)type{
    
    MHHomeButtonCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self) forIndexPath:indexPath];
    
    if (cell==nil) {
      [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(self)
                 ];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self) forIndexPath:indexPath];
    }
    
    if (type == MHHomeButtonTypeServer) {
        cell.topView.hidden = NO ;
        cell.rightView.hidden = NO ;
        cell.leftView.hidden = NO ;
        cell.bottomView.hidden = NO ;
    }
   return cell;
}


- (void)mh_collectionViewCellWithModel:(MHHomeFunctionalModulesModel*)model {
    self.mh_titleLabel.text = model.function_name;
    if([model.function_icon_url hasPrefix:@"http://"] || [model.function_icon_url hasPrefix:@"https://"]){
        [self.mh_imageView sd_setImageWithURL:[NSURL URLWithString:model.function_icon_url]];
        return;
    }
    self.mh_imageView.image = [UIImage imageNamed:model.function_icon_url];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mh_titleLabel.textColor = MColorToRGB(0X475669);
}

@end
