//
//  MHActivityStausView.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandler)(void);

typedef NS_ENUM(NSInteger, MHActivityStatusViewType){
    /**
     *   活动已取消
     */
    MHActivityStatusViewTypeCancel  = 0,
    
    /**
     *   活动进行中
     */
    MHActivityStatusViewTypeGoing = 1,
    
    
    /**
     *  活动结束
     */
    MHActivityStatusViewTypeEnd = 2,
    
    /**
     *   活动管理
     */
    MHActivityStatusViewTypeManagement = 3,
    
    
    /**
     *  发布活动
     */
    MHActivityStatusViewTypeRelease = 4
    
};
@interface MHActivityStatusView : UIView

@property (nonatomic, copy)   ActionHandler actionHandler;
@property (nonatomic, assign) MHActivityStatusViewType type;

+ (instancetype)activityViewWithStatus:(MHActivityStatusViewType)type actionBlock:(ActionHandler)actionHandler;


@end
