//
//  MHVoNaviBigTitleHeaderView.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoNaviBigTitleHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *countLB;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;
+ (instancetype)voNaviBigTitleHeaderView;

@end
