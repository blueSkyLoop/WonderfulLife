//
//  MHVoInviteJoinDetailScrollView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoInviteJoinDetailScrollView : UIScrollView
@property (nonatomic, copy) void(^clickInviteBlock)();
@property (nonatomic, copy) void(^goinDetailBlock)(NSString *url);
@property (nonatomic, copy) NSString *headcount;
@property (nonatomic, assign) BOOL hiddenJoinButton;
@property (nonatomic, strong) UIImageView *swipeUpImv;
@end
