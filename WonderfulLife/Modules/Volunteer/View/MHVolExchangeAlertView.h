//
//  MHVolExchangeAlertView.h
//  WonderfulLife
//
//  Created by Beelin on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolExchangeAlertView : UIView
@property (nonatomic, copy) void(^shootBlock)(BOOL simply);
+ (instancetype)volExchangeAlertView;
@end
