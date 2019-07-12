//
//  MHVoHomePageHeaderView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoHomePageHeaderView : UIView

@property (nonatomic, copy) void(^clickPushServerBlock)();
@property (nonatomic, copy) void(^clickPushCultivateBlock)();
@property (nonatomic, copy) void(^clickPushVolunteerIntrolBlock)();


@property (nonatomic, copy) NSString *headcount;

+ (instancetype)voHomePageHeaderView;
@end
