//
//  LIntegralsPayFailureView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"
#import "ReactiveObjC.h"

@interface LIntegralsPayFailureView : UIView
@property (weak, nonatomic) IBOutlet MHThemeButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *compleButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)RACSubject *failureSubject;

+ (LIntegralsPayFailureView *)loadViewFromXib;

@end
