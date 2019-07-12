//
//  MHVolActivityInfoCardController.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHVolActivityInfoCardType){
    
    /** */
    MHVolActivityInfoCardTypeSer  = 0,
    
    /** */
    MHVolActivityInfoCardTypeActivity = 1
};

@interface MHVolActivityInfoCardController : UIViewController
@property (strong,nonatomic) NSNumber *activtyId; // 项目id
@property (strong,nonatomic) NSNumber *volunteerId; // 志愿者id
@property (strong,nonatomic) NSNumber *userId; // 用户id
@property (strong,nonatomic) NSNumber *teamId; // 队伍id
@property (nonatomic, assign) NSInteger  role;   // 用户的身份  ： 队员：0、队长：1、总队长：9


@property (nonatomic, assign) MHVolActivityInfoCardType type;

@end
