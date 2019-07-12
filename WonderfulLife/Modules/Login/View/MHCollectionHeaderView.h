//
//  MHCollectionHeaderView.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCollectionHeaderView : UICollectionReusableView
@property (strong,nonatomic) UIView *topLine;
@property (strong,nonatomic) UIView *bottomLine;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIImageView *imageView; ///default is hidden
@end
