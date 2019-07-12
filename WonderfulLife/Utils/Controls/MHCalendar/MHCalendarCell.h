//
//  MHCalendarCell.h
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titileLabel; //!< 标示日期（几号）
@property (weak, nonatomic) CAShapeLayer *shapeLayer;

- (void)configureAppearance;
- (void)performSelecting;
@end
