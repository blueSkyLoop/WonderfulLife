//
//  MHCeSelRoomController.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  选择房间   tip: storyboard

#import <UIKit/UIKit.h>

#import "MHStructAreaModel.h"
#import "MHStructBuildingModel.h"
#import "MHStructUnitModel.h"
#import "MHStructRoomModel.h"

@class  MHStructAreaModel,
        MHStructBuildingModel,
        MHStructUnitModel,
        MHStructRoomModel,
        MHCommunityModel;

typedef void(^MHCeSelRoomCallBack)(MHStructAreaModel *,MHStructBuildingModel *,MHStructUnitModel *,MHStructRoomModel *);

@interface MHCeSelRoomController : UIViewController
@property (copy,nonatomic) MHCeSelRoomCallBack callBack;
@property (strong,nonatomic) MHCommunityModel *currentCommunity;
@end
