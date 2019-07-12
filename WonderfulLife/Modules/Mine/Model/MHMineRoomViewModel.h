//
//  MHMineRoomViewModel.h
//  WonderfulLife
//
//  Created by 哈马屁 on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@interface MHMineRoomViewModel : NSObject

@property (nonatomic, strong , readonly) RACCommand *roomListCommand;


@end
