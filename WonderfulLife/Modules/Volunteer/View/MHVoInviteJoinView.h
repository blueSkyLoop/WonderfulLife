//
//  MHVoInviteJoinView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoInviteJoinView : UIView
@property (nonatomic, copy) void(^clickInviteBlock)();
@property (nonatomic, copy) void(^clickPanUpBlock)();

@property (nonatomic, copy) NSString *headcount;

- (void)showSelf;
@end
