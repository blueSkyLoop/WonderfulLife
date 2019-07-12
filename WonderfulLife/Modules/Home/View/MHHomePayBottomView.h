//
//  MHHomePayBottomView.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomePayBottomViewHandler)(void);  // 缴费按钮回调

@interface MHHomePayBottomView : UIView
/**
 总计费用
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 缴费按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *payButton;
/**
 缴费回调
 */
@property (nonatomic, copy) HomePayBottomViewHandler payHandler;

/**
 加载物业缴费底部工具栏
 */
+ (instancetype)loadHomePayBottomView;

@end
