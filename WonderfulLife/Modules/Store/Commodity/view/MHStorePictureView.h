//
//  MHStorePictureView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHStorePictureView : UIView

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *picArr;

@property (nonatomic,strong)NSMutableArray <NSString *>*bigPicArr;

@end
