//
//  MHHomeMyRoomController.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHHomePayMyRoomControllerTypePay,
    MHHomePayMyRoomControllerTypeMine,
} MHHomePayMyRoomControllerType;
@interface MHHomePayMyRoomController : UIViewController

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,copy) void (^refreshDataList)();
@property (nonatomic,assign) BOOL fromeHome;
@property (nonatomic,assign) NSInteger selectedButtonIndex;
@property (nonatomic,assign) MHHomePayMyRoomControllerType type;

@end
