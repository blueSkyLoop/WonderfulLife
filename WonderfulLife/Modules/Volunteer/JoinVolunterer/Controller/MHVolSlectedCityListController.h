//
//  MHVolSlectedCityListController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHCityModel,MHCommunityModel;
typedef void(^MHVolSlectedCallBack)(MHCityModel *city,MHCommunityModel *community);
@interface MHVolSlectedCityListController : UIViewController

@property (copy  ,nonatomic) MHVolSlectedCallBack callBack;
@property (strong,nonatomic) MHCityModel *currentCity;
@end
