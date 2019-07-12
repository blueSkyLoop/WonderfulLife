//
//  MHVoAddressAddController.h
//  WonderfulLife
//
//  Created by zz on 26/08/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHVoAddressAddType) {
    MHVoAddressAddTypeNormal,
    MHVoAddressAddTypeFillDatas,
    MHVoAddressAddTypeFillDatasNoRoom
};

@class MHCityModel,MHCommunityModel;
typedef void(^MHLoPlotCallBack)(MHCityModel *city,MHCommunityModel *community);
@interface MHVoAddressAddController : UIViewController
@property (copy  ,nonatomic) void (^confirmBlock)(NSString *);
@property (copy  ,nonatomic) MHLoPlotCallBack callBack;
@property (assign,nonatomic) MHVoAddressAddType type;
@property (copy  ,nonatomic) NSString *communityName;
@property (copy  ,nonatomic) NSString *cityName;

@end
