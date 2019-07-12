//
//  MHVoSeButtonHeaderView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoSeButtonHeaderView : UIView

@property (nonatomic, copy) void(^clickBlock)(NSInteger tag);
+ (instancetype)voSeButtonHeaderView;
@end
