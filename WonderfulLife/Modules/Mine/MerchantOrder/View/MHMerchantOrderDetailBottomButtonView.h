//
//  MHMerchantOrderDetailBottomButtonView.h
//  WonderfulLife
//
//  Created by zz on 27/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"

typedef NS_ENUM(NSUInteger, MHMerchantOrderBottomButtonType) {
    MHMerchantOrderBottomButtonTypeUnpaid,
    MHMerchantOrderBottomButtonTypeUnused,
    MHMerchantOrderBottomButtonTypeRefund,
    MHMerchantOrderBottomButtonTypeReviews,
    MHMerchantOrderBottomButtonTypeChecking
};

@protocol MHMerchantOrderDetailBottomButtonDelegate <NSObject>

/**
 周边商户订单详情底部按钮事件回调

 @param type 底部按钮类型
 @param leftClicked  当 type 为 refund、reviews 时为单个按钮事件，点击按钮，该 bool 值为 yes，当 type 为 Checking 时，是点击拒绝按钮时发生的事件回调。
 @param rightClicked 当 type 为 Checking 类型时，是点击同意按钮时发生的事件回调。此时回调的 bool 值为 yes。
 */
- (void)MerchantOrderDetailBottomButtonType:(MHMerchantOrderBottomButtonType)type leftButtonClick:(BOOL)leftClicked rightButtonClick:(BOOL)rightClicked;

@end

@interface MHMerchantOrderDetailBottomButtonView : UIView
@property (nonatomic, strong)MHThemeButton *themeButton;

@property (nonatomic,assign) MHMerchantOrderBottomButtonType type;
@property (nonatomic,weak) id<MHMerchantOrderDetailBottomButtonDelegate> delegate;
@end
