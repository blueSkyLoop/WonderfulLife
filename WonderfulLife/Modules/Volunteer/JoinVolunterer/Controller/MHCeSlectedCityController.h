//
//  MHCeSlectedCityController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  选择城市

#import <UIKit/UIKit.h>
@class MHCityModel,MHCommunityModel;
typedef void(^MHCeSlectedCityCallBack)(MHCityModel *city,MHCommunityModel *community);
typedef NS_ENUM(NSInteger, MHCeSlectedCityType){
    
    /** 普通*/
    MHCeSlectedCityType_Normal  = 0,
    
    /** 志愿者 : 参与服务项目（志愿者流程） & 服务项目列表（已是志愿者）*/
    MHCeSlectedCityType_Vol
};
@interface MHCeSlectedCityController : UIViewController
@property (copy,nonatomic) MHCeSlectedCityCallBack callBack;



/**
 *  控制选择小区界面的标题
 *  MHCeSlectedCityType_Vol : 选择城市 & 小区
 *  MHCeSlectedCityType_Normal  : 所在城市 & 小区
 */
@property (nonatomic, assign) MHCeSlectedCityType type;

- (instancetype)initWithType:(MHCeSlectedCityType)type ;

@end
