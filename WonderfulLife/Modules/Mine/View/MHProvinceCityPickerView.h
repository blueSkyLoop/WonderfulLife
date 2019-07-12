//
//  MHProvinceCityPickerView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMineNative;
@interface MHProvinceCityPickerView : UIView
@property (nonatomic,copy) void (^confirmBlock)(MHMineNative *);
@property (nonatomic,strong) NSArray *provinceCities;

- (void)show;
@end
