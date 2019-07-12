//
//  MHVolSerComDetailController.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHVolSerComDetailType){
    
    /** 积分明细详情页*/
    MHVolSerComDetailTypeScoreRecord  = 0,
    
    /** 服务时长详情页*/
    MHVolSerComDetailTypeAttendanceDetail = 1
};

@interface MHVolSerComDetailController : UIViewController
@property (nonatomic, assign) MHVolSerComDetailType type;

@property (nonatomic, strong) NSNumber  *detail_Id;

@end
