//
//  MHReportRepairCallPhoneView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"

@interface MHReportRepairCallPhoneView : MHBaseView
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,copy)void (^callPhoneBlock)(void);
@end
