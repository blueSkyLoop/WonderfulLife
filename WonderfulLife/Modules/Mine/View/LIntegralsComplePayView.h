//
//  LIntegralsComplePayView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"
#import "ReactiveObjC.h"
#import "LIntegralsGoodsModel.h"

@interface LIntegralsComplePayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *integralsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashierLabel;
@property (weak, nonatomic) IBOutlet MHThemeButton *compleButton;

@property (nonatomic,strong)RACSubject *payCompleSubject;

+ (LIntegralsComplePayView *)loadViewFromXib;

- (void)configWithInfor:(LIntegralsGoodsModel *)model;

@end