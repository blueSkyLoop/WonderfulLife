//
//  MHReportRepairCancelView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"

@interface MHReportRepairCancelView : MHBaseView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic,copy)void(^cacelSureBlock)(void);

@end
