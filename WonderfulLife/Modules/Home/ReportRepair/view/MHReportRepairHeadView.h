//
//  MHReportRepairHeadView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseView.h"

@interface MHReportRepairHeadView : MHBaseView
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonMiddle;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapLayoutOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapLaoutTwo;

@property (nonatomic,copy)void(^headItemClikBlock)(NSInteger index);

- (void)makeSelectIndex:(NSInteger)index;

@end
