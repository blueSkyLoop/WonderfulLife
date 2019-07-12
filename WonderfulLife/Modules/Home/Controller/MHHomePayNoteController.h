//
//  MHHomePayNoteController.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHMineRoomModel;
@interface MHHomePayNoteController : UIViewController
@property (nonatomic,assign) BOOL hasMoreRoom;
@property (nonatomic,strong) MHMineRoomModel *room;
/** 是否从房间列表来 */
@property (nonatomic,assign) BOOL fromList;
@property (nonatomic,assign) NSInteger selectedButtonIndex;

@property (nonatomic,copy) void (^refreshBillBlock)();
@end
