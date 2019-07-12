//
//  MHVoSeReviewButtonView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoSeReviewButtonView : UIView
@property (nonatomic, copy) void(^clickReviewBlock)();
@property (nonatomic, copy) void(^clickReviewedBlock)();
+ (instancetype)voSeReviewButtonView;

- (void)clickReviewedButton;
@end
