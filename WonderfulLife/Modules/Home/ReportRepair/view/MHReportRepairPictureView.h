//
//  MHReportRepairPictureView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHBaseCollectionDelegateModel.h"

@interface MHReportRepairPictureModel : NSObject

@property (nonatomic,copy)NSString *pictreUrlStr;

@property (nonatomic,strong)UIImage *image;

//是否是拍照选项
@property (nonatomic,assign)BOOL isTakePhoto;

@end

@interface MHReportRepairPictureDelegateModel : MHBaseCollectionDelegateModel


@property (nonatomic,copy)void(^mhReportPictureCloseBlock)(MHReportRepairPictureModel *amodel);

@property (nonatomic,assign)BOOL needShowCloseButton;

@end



@interface MHReportRepairPictureView : UIView

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

//默认3张
@property (nonatomic,assign)NSInteger limitNum;

//默认YES
@property (nonatomic,assign)BOOL needShowTakePhoto;

//默认YES
@property (nonatomic,assign)BOOL needShowCloseButton;

//传图片即可，内部会再进行模型转换 可传图片名字和图片实例
@property (nonatomic,copy)NSArray *pictureArr;
//默认 19
@property (nonatomic,assign)CGFloat itemGap;
//默认 宽高都为 (MScreenW - self.itemGap * 2) / 3.0;
@property (nonatomic,assign)CGSize itemSize;

@property (nonatomic,copy)void(^pictureRemoveBlock)(MHReportRepairPictureModel *model,NSInteger removeIndex);

@property (nonatomic,copy)void(^pictreCollectionViewDidSelectBlock)(NSIndexPath *indexPath,MHReportRepairPictureModel *cellModel);


@end
