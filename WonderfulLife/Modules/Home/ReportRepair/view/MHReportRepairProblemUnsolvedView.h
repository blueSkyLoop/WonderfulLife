//
//  MHReportRepairProblemUnsolvedView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"

#import "YYTextView.h"

@interface MHReportRepairProblemUnsolvedView : MHBaseView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UIView *textBigBgView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCenterY;

@property (nonatomic,strong)YYTextView *textView;


@property (nonatomic,copy)void (^solvedBlock)(NSString *evaluatStr);

@end
