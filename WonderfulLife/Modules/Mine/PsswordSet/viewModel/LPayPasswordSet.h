//
//  LPayPasswordSet.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LPayPasswordSet : NSObject

@property (nonatomic,strong,readonly)RACCommand *payPasswordCommand;

@end
