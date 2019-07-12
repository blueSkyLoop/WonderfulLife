//
//  MHVolGifAlertView.h
//  WonderfulLife
//
//  Created by Beelin on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolGifAlertView : UIView
@property (nonatomic, copy) void(^shootBlock)();
@property (nonatomic, assign, getter=isSimply) BOOL simplyFlag;

+ (instancetype)volGifAlertView;
@end
