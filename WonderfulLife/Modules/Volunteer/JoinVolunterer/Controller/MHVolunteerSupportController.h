//
//  MHVolunteerSupportController.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  需要什么帮助

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MHVolunteerSupportType){
    
    /** 志愿者申请流程*/
    MHVolunteerSupportTypeNormal  = 0,
    
    /** 志愿者资料卡*/
    MHVolunteerSupportTypeVolCard = 1
};
@interface MHVolunteerSupportController : UIViewController


@property (nonatomic, assign) MHVolunteerSupportType type;

@end
