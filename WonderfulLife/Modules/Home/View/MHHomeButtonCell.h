//
//  MHHomeButtonCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeCollectionViewCellProtocol.h"


typedef NS_ENUM(NSInteger, MHHomeButtonType){
    
    /**
     *  首页样式
     */
    MHHomeButtonTypeNormal  = 0,
    
    /**
     *  美好服务
     */
    MHHomeButtonTypeServer = 1
};
@interface MHHomeButtonCell : UICollectionViewCell<MHHomeCollectionViewCellProtocol>


@property (nonatomic,weak) id<MHHomeCollectionViewCellDelegate> delegate;

@property (nonatomic, assign) MHHomeButtonType type;

@property (weak, nonatomic) IBOutlet UIImageView *mh_imageView;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIView *rightView;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath homeButtonType:(MHHomeButtonType)type;

@end
