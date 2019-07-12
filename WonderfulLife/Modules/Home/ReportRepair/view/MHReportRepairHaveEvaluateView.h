//
//  MHReportRepairHaveEvaluateView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBaseView.h"
#import "XHStarRateView.h"

@interface MHReportRepairHaveEvaluateView : MHBaseView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;

@property (nonatomic,strong)XHStarRateView *evaluateStartView;

@property (nonatomic,assign)CGFloat score;


@end
