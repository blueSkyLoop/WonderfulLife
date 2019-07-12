//
//  MHYMCalendarCell.h
//  WonderfulLife
//
//  Created by zz on 12/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHYMCalendarCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titileLabel; //!< 标示日期（几号）
@property (weak, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) BOOL isCurrentDate;
@end
