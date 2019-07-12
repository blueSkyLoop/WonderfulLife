//
//  MHHomePayDetailsFooterView.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHHomePayDetailsFooterView : UIView

/**
 缴费金额
 */
@property (weak, nonatomic) IBOutlet UILabel *paymentAmountLabel;
/**
 积分抵扣
 */
@property (weak, nonatomic) IBOutlet UILabel *scoreDeductionLabel;
/**
 实际支付
 */
@property (weak, nonatomic) IBOutlet UILabel *actualPaymentLabel;

/**
 支付方式
 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
/**
 支付时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 加载物业缴费底部视图
 */
+ (instancetype)loadPayDetailsFooterView;

@end
