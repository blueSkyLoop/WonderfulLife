//
//  MHVoSerIntegralDetailsHeaderView.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVoSerIntegralDetailsModel,MHVoSerIntegralDetailsHeaderView;

@protocol MHVoSerIntegralDetailsHeaderViewDelegate <NSObject>
@optional
- (void)didSelectHeaderViewBtn:(UIButton *)sender;

@end

@interface MHVoSerIntegralDetailsHeaderView : UIView

@property (nonatomic, weak) id <MHVoSerIntegralDetailsHeaderViewDelegate> delegate;

@property (strong,nonatomic) MHVoSerIntegralDetailsModel *model;

+ (instancetype)voSerIntegralDetailsHeaderView;


@end
