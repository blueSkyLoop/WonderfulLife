//
//  MHVoActivityListHeaderView.h
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoActivityListHeaderView : UIView
@property (nonatomic, copy) void(^clickBlock)(NSInteger tag);
+ (instancetype)voSeButtonHeaderView;
//切换到进行中的状态
- (void)changeToDoingStatus;
@end
